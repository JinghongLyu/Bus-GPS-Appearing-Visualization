// declare arrays for lat, lon and time, to contain Strings
float [] lat, lon, x, y;
int [] hour, minute, second;
int [] Time;
int [] counts;
color colours;
int i;
int t;
int loopTime;


void setup()
{
    size(500,500);
    loadData();
    background(0,0,0); // change the background color later if wish
}


void draw()
{
    Mapping();
    //replay();
}


void loadData()
{
    // load data
    String [] sData = loadStrings("buses2.csv");
    
    
    // define size of lat, lon, hour, minute, second and Time, remove something i can't remember
    lat = new float[sData.length - 1];
    lon = new float[sData.length - 1];
    hour = new int[sData.length - 1];
    minute = new int[sData.length - 1];
    second = new int[sData.length - 1];
    Time = new int[sData.length - 1];
    counts = new int[168];

    
    for (int i = 1; i < sData.length; i++)
    {
        //split all the rows into arrays
        String [] thisRow = split(sData[i], ",");
        // write the correct cell to the lat and lon
        lon[i-1] = float(thisRow[1]);
        lat[i-1] = float(thisRow[2]);
        
        //split the time column by ":" to calculate seconds
        String [] SplitTimeRow = split(thisRow[13], ":");
        //write the correct cell to hours, minutes, seconds
        hour[i-1] = int(SplitTimeRow[0]);
        minute[i-1] = int(SplitTimeRow[1]);
        second[i-1] = int(SplitTimeRow[2]);
  
        
        //calculate seconds
        Time[i-1] = hour[i-1]*3600 + minute[i-1]*60 + second[i-1];
        //println(Time[i-1]);
    }
        
    
    // create the counts array to store
    //the number of data that appeared in 1 second
    //so can change the frameRate: frameRate(counts[n]) -> display n points in 1 second
    counts[0] = 1;
    for (int t = 0; t <= max(Time); t++)
    {
        for (int i = 1; i < Time.length; i++)
        {
            if (Time[i] == t)
            {
                counts[t]++;
            }
        }
    }
    //println(counts);
    
      
    x = new float[lon.length];
    y = new float[lat.length];
}


void Mapping()
{
    fill(0);
    noStroke();
    rect(0,0,200,70);
    textSize(10);
    fill(255,72,210); text("Pink: xxxx",5,26);
    fill(251,255,72); text("Yellow: ", 5, 38);
    fill(255,0,0); text("Red",5,50);
    fill(255,255,255); text("While: ", 5, 62);

    
    // loop to map points
    for (int t = 0; t <= max(Time); t++)
    {
        if (frameCount < x.length)
        {
            if (Time[frameCount] == t)
            {
                //display digital clock
                textSize(12); fill(255);
                text("11/11/2011:    " + nf(hour[frameCount],2) + ": " 
                                       + nf(minute[frameCount],2) + ": "
                                       + nf(second[frameCount],2),5,12);
                // so the data can display in just 1 second
                frameRate(counts[t]);
                
                for (int i = 0; i < lat.length; i++)
                {
                    if ((Time[i] == t) && (Time[i] <= max(Time)))
                    {
                        x[i] = map(lon[i], min(lon), max(lon), 0, width);
                        y[i] = map(lat[i], min(lat), max(lat), height, 0);
                        // change colour accorting to t
                        if (0 < t && t < 60){ stroke(255,0,0);}
                        if (60 <= t && t < 120){ stroke(0,255,0);}
                        if (120 <= t && t < max(Time)){ stroke(0,0,255);}
                        point(x[i], y[i]);
                    }           
                }           
            }            
        }
        else
        {
            replay();
        }
    }
}


void replay()
{
    background(0);
    frameCount = 1;
    loopTime = millis();
}


void mousePressed()
{
    background(0);
    t = 0;
    frameCount = 1; 
    redraw();
}