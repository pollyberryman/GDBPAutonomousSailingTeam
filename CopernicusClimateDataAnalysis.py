import eccodes as ec
import pandas as pd
import cdsapi
from tempfile import TemporaryDirectory
import os
import time as t
import datetime as dt
from timezonefinder import TimezoneFinder
import pytz
import numpy as np


def get_data(request,dataset,directory):
    client = cdsapi.Client()
    thisdir = os.getcwd()
    with TemporaryDirectory() as tempdir:
        timenow = t.strftime('%m_%d_%Y_%H.%M.%S')
        os.chdir(tempdir)
        client.retrieve(dataset, request).download()
        latitude= request["area"][0]-0.5
        longitude= request["area"][1]+0.5
        tf = TimezoneFinder()
        timezone_name = tf.timezone_at(lat=latitude, lng=longitude)
        print(timezone_name)

        num_vars = len(request["variable"])

        filename = f"{timenow}.grib"
        filelocation = os.path.join(directory,filename)
        
        tempfile = os.listdir()
        tempfile = str(tempfile[0]) 
        os.rename(tempfile, filelocation)
        os.chdir(thisdir)
        return filename, timezone_name



def example(directory,filename):
    fname = os.path.join(directory,filename)
    f = open(fname,'rb')
 
    count = 1
    data = {}
    while 1:
        gid = ec.codes_grib_new_from_file(f)
        if gid is None: break
        print ("\n\n-- GRIB %d --" % (count))
 
        edition = ec.codes_get(gid,'edition')
        shortName = ec.codes_get(gid,'shortName')
        date = ec.codes_get(gid,'date')
        time = ec.codes_get(gid,'time')
        step = ec.codes_get(gid,'step')
        levType = ec.codes_get(gid,'typeOfLevel')
        level = ec.codes_get(gid,'level')
        name = ec.codes_get(gid,'name')

        datetime = str(date)+str(time)
        year = int((str(date))[0:4])
        month = int((str(date))[4:6])
        day = int((str(date))[6:8])
        datenice = dt.datetime(year,month,day)
        

        if step == 24:
            step = 0
            dateActual = datenice + dt.timedelta(1)
            year = int((str(dateActual))[0:4])
            month = int((str(dateActual))[5:7])
            day = int((str(dateActual))[8:10])
            time = max(time,step*100)
            date = int(str(dateActual)[0:4] + str(dateActual)[5:7] + str(dateActual)[8:10])
            datetime = str(date) + str(time)
            fulldatetime = dt.datetime(year, month, day, time)
        else:
            time = max(time,step*100)
            datetime = str(date)+str(time)
            if time < 1000:
                fulldatetime = dt.datetime(year, month, day, int(str(time)[0]))
            else:
                fulldatetime = dt.datetime(year, month, day, int(str(time)[0:2]))
        

        print("Edition=%d Parameter=%s typeOfLevel=%s level=%d date=%d time=%d name=%s\n" % 
              (edition, shortName, levType, level, date, time, name))
 
        values = ec.codes_get_array(gid,'values')
 
        print("First 20 values:\n----------------\n")
        #for i in range(20):
        #    print("%.4f" % (values[i]))
 
        maximum = ec.codes_get(gid,'max')
        minimum = ec.codes_get(gid,'min')
        average = ec.codes_get(gid,'average')


        if count == 1:
            data['years'] = [year]
            data['months'] = [month]
            data['days'] = [day]
            data['dates'] = [date]
            data['times'] = [time]
            data['datetimes'] = [datetime]
            data['fulldatetimes'] = [fulldatetime]
            
            
        else:
            if not datetime in data['datetimes']:
                data['years'].append(year)
                data['months'].append(month)
                data['days'].append(day)
                data['datetimes'].append(datetime)
                data['dates'].append(date)
                data['times'].append(time)
                data['fulldatetimes'].append(fulldatetime)
                
            
        
        if name in data:
            data[name].append(average)
        else:
            data[name] = [average]


        print("max = %.4f  min = %.4f  average = %.4f\n" % (maximum, minimum, average))
 
        ec.codes_release(gid)
        count += 1
    
    f.close()
    return  data

def flux2(df, listOfFlux):
    for column in df:
        if column in listOfFlux:
            for i in range(1,len(df)):
                if df.at[i, 'times'] == 100:
                    df.at[i, str(column)+' Delta'] = (df.iloc[i][column])/3600
                else:
                    df.at[i, str(column)+' Delta'] = (df.iloc[i][column]- df.iloc[i-1][column])/3600
            df = df.sort_index().reset_index(drop=True)   
            print (df)    
            for j in range(len(df)):   
                if j<(len(df)-1):
                    df.at[j, str(column)+' Delta'] = df.iloc[j+1][str(column)+' Delta']
            
            for m in range(len(df)):
                df.loc[m+0.5]= df.loc[m]
                df.at[m+0.5, 'times'] = df.at[m, 'times']+99
                df.at[m+0.5, 'datetimes'] = str(df.at[m+0.5, 'dates'])+str(df.at[m+0.5, 'times'])
                df.at[m+0.5, 'fulldatetimes'] = df.at[m, 'fulldatetimes'] + dt.timedelta(minutes=59)               
            df = df.sort_index().reset_index(drop=True)
            
            for n in range(len(df)):
                df.at[n,'times'] = (df.iloc[n]['times'])/100
            
            notConsecutive = []
            for n in range (3,(len(df)-2)):
                a = dt.date(int(df.at[n+1, 'years']),int(df.at[n+1, 'months']),int(df.at[n+1, 'days']))
                b = dt.date(int(df.at[n, 'years']),int(df.at[n, 'months']),int(df.at[n, 'days']))
                if (a-b)>dt.timedelta(1):
                    notConsecutive.append(n)      
            print('Not consecutive rows: ',notConsecutive)
            
            for p in notConsecutive:
                df.at[p-1,str(column)+' Delta'] = df.iloc[p-2][str(column)+' Delta']
                df.at[p,str(column)+' Delta'] = df.iloc[p-2][str(column)+' Delta']
            
    print (df)

    return df

def correctNonFlux(df, notFluxVariable):
    for column in df:
        if column in notFluxVariable:
            for w in range(1, len(df)-1):
                df.at[w, column] = df.iloc[w+1][column]  
                
    return df

def correctTimeZones(df, timezone_name, listOfDateTimeColumns):
    for column in df:
        if column not in listOfDateTimeColumns:
            for k in df.fulldatetimes:
                Yy = k.year
                Mm = k.month
                Dd = k.day
                hh = k.hour
                mm = k.minute
                ss = k.second
                utc_time = dt.datetime(Yy,Mm,Dd,hh,mm,ss,tzinfo=pytz.timezone('UTC'))
                target_timezone = pytz.timezone(timezone_name)
                local_time = utc_time.astimezone(target_timezone)
                fmt = '%H:%M'
                time_adjusted = local_time.strftime(fmt)
                hh = int(time_adjusted[0:2])
                mm = int(time_adjusted[3:5])
                index = df[df['fulldatetimes']==k].index
                loc = int(index[0])
                df.at[loc,'timeAdjusteds'] = time_adjusted
                df.at[loc,'fulldatetimesNEW'] = dt.datetime(Yy,Mm,Dd,hh,mm)
                df['fulldatetimesNEW'] = pd.to_datetime(df['fulldatetimesNEW'])
                df_sorted = df.sort_values(by='fulldatetimesNEW')
                df_sorted = df_sorted.reset_index(drop=True)
    print(df_sorted)

    return df_sorted


######################################################################

#dataset = "reanalysis-era5-land"
dataset = "reanalysis-era5-single-levels"
request = {
    "product_type": ["reanalysis"],
    "variable": ["10m_u_component_of_wind",
        "10m_v_component_of_wind",
        "mean_wave_direction",
        "mean_wave_period",
        "significant_height_of_combined_wind_waves_and_swell"
        ],
    "year": [ "2025"],
    "month": [  
        "01", "02", "03",
        "04", "05", "06",
        "07", "08", "09",
        "10", "11", "12"
        ],
    "day": ["01", "02", "03",
        "04", "05", "06",
        "07", "08", "09",
        "10", "11", "12",
        "13", "14", "15",
        "16", "17", "18",
        "19", "20", "21",
        "22", "23", "24",
        "25", "26", "27",
        "28", "29", "30",
        "31"],
    "time": [
        "00:00", "01:00", "02:00",
        "03:00", "04:00", "05:00",
        "06:00", "07:00", "08:00",
        "09:00", "10:00", "11:00",
        "12:00", "13:00", "14:00",
        "15:00", "16:00", "17:00",
        "18:00", "19:00", "20:00",
        "21:00", "22:00", "23:00"
    ],
    "data_format": "grib",
    "download_format": "unarchived",
    "area": [34, -42.5, 33, -41.5]
}

listOfDateTimeColumns = ['years', 'months', 'days', 'dates', 'times',  'datetimes', 'fulldatetimes']
listOfFlux = ["Surface short-wave (solar) radiation downwards"]
notFluxVariable = ['2 metre dewpoint temperature', '2 metre temperature',"10m_u_component_of_wind",
        "10m_v_component_of_wind",
        "mean_wave_direction",
        "mean_wave_period",
        "significant_height_of_combined_wind_waves_and_swell",
        "instantaneous_10m_wind_gust"]
directory='C:\\Users\\Polly Berryman\\GitProjects\\GDBPAutonomousSailingTeam\\'
filename, timezone_name = get_data(request=request,dataset=dataset,directory=directory)
filenamenogrib = os.path.splitext(filename)[0]
originaldf = directory+filenamenogrib+'_original'+'.csv'
filenamecsv = directory+filenamenogrib+'.csv'

data = example(directory,filename)
print(data)
df = pd.DataFrame(data)
print(df)

#df.to_csv(originaldf)
#df = flux2(df, listOfFlux)
#df = correctNonFlux(df, notFluxVariable)
#df = correctTimeZones(df, timezone_name, listOfDateTimeColumns)
#print(df)
#df.to_csv(filenamecsv)

df['UnixSeconds'] = df['fulldatetimesNEW'].astype('int64') // 10**9

U = df['10 metre U wind component']
V = df['10 metre V wind component']
df['windSpeed'] = np.sqrt(U*U + V*V)
df['windDirRad'] = np.arctan2(-U, -V)    # meteorological direction (from)


df = df.rename(columns={
    '10 metre U wind component': 'windU10',
    '10 metre V wind component': 'windV10',
    'Mean wave direction': 'waveDirection',
    'Mean wave period': 'wavePeriod',
    'Significant height of combined wind waves and swell': 'waveHeight'
})

df['waveDirRad'] = np.deg2rad(df['waveDirection'])


df_modelica = df[[
    'UnixSeconds',
    'years',
    'months',
    'days',
    'times',     
    'windU10',
    'windV10',
    'windSpeed',
    'windDirRad',
    'waveDirRad',
    'wavePeriod',
    'waveHeight'
]]

print(df_modelica)

df_modelica = df_modelica.sort_values(by='UnixSeconds').reset_index(drop=True)

final_name = f"{directory}FINAL_{filenamenogrib}.csv"
df_modelica.to_csv(final_name, index=False)
