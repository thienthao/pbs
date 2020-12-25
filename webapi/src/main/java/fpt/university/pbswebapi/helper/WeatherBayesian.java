package fpt.university.pbswebapi.helper;

import org.springframework.util.ResourceUtils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class WeatherBayesian {

    static ArrayList<ArrayList<String>> data = new ArrayList<ArrayList<String>>();


    public ArrayList<ArrayList<String>> readTable(){
        ArrayList<String> d = null;
        ArrayList<ArrayList<String>> t = new ArrayList<ArrayList<String>>();
        try {
            File file = ResourceUtils.getFile("classpath:photographing.txt");
            InputStreamReader isr = new InputStreamReader(new FileInputStream(file));
            BufferedReader bf = new BufferedReader(isr);
            String str = null;
            while((str = bf.readLine()) != null) {
                d = new ArrayList<String>();
                String[] str1 = str.split(",");
                for(int i = 1; i < str1.length ; i++) {
                    d.add(str1[i].replace(" ", ""));
                }
                t.add(d);
                data = t;
            }
            bf.close();
            isr.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("File does not exist!");
        }
        return t;
    }

    public double denominator(String outlook, String temp, String humidity, String windy) {
        double result = 0;
        int count1 = 0;
        int count2 = 0;
        int count3 = 0;
        int count4 = 0;
        for(int i = 0; i < data.size() ;i++) {
            if(data.get(i).get(0).equalsIgnoreCase(outlook)) {
                count1++;
            }
            if(data.get(i).get(1).equalsIgnoreCase(temp)) {
                count2++;
            }
            if(data.get(i).get(2).equalsIgnoreCase(humidity)) {
                count3++;
            }
            if(data.get(i).get(3).equalsIgnoreCase(windy)) {
                count4++;
            }
        }
        result = (count1 / (data.size()*1.0))*(count2 / (data.size()*1.0))*(count3 / (data.size()*1.0))*(count4 / (data.size()*1.0));
        return result;
    }

    public double moleculeIsShooting(String shooting, String outlook, String temp, String humidity, String windy) {
        double result = 0;
        int countCanShoot = 0;
        int count1 = 0;
        int count2 = 0;
        int count3 = 0;
        int count4 = 0;
        for(int i = 0; i < data.size() ;i++) {
            System.out.println(i);
            if(data.get(i).get(4).equalsIgnoreCase(shooting)) {
                countCanShoot++;
            }
            if(data.get(i).get(0).equalsIgnoreCase(outlook) && data.get(i).get(4).equalsIgnoreCase(shooting)) {
                count1++;
            }
            if(data.get(i).get(1).equalsIgnoreCase(temp) && data.get(i).get(4).equalsIgnoreCase(shooting)) {
                count2++;
            }
            if(data.get(i).get(2).equalsIgnoreCase(humidity) && data.get(i).get(4).equalsIgnoreCase(shooting)) {
                count3++;
            }
            if(data.get(i).get(3).equalsIgnoreCase(windy) && data.get(i).get(4).equalsIgnoreCase(shooting)) {
                count4++;
            }
        }
        result = (countCanShoot / (data.size()*1.0))*(count1 / (countCanShoot*1.0))*(count2 / (countCanShoot*1.0))*(count3 / (countCanShoot*1.0))*(count4 / (countCanShoot*1.0));
        return result;
    }

    public String compared(String outlook, String temp, String humidity, String windy) {
        String str = null;
        double d1 = 0,d2 = 0;
        d1 = moleculeIsShooting("Y", outlook, temp, humidity, windy)*1.0 / denominator(outlook, temp, humidity, windy);
        d2 = moleculeIsShooting("N", outlook, temp, humidity, windy)*1.0 / denominator(outlook, temp, humidity, windy);
        if(d1 > d2) {
            str = "Thời tiết thuận lợi để chụp ảnh";
        }else {
            str = "Thời tiết không thuận lợi để chụp ảnh";
        }
        System.out.println("Probability of photoshoot:"+d1);
        System.out.println("No chance of photoshoot:"+d2);
        System.out.println(str);
        return str;
    }

    public String comparedForDetail(String outlook, String temp, String humidity, String windy, String datetime) {
        String str = null;
        double d1 = 0,d2 = 0;
        d1 = moleculeIsShooting("Y", outlook, temp, humidity, windy)*1.0 / denominator(outlook, temp, humidity, windy);
        d2 = moleculeIsShooting("N", outlook, temp, humidity, windy)*1.0 / denominator(outlook, temp, humidity, windy);
        if(d1 > d2) {
//            str = "Thời tiết thuận lợi để chụp ảnh";
        }else {
            str = "Thời tiết ngày " + datetime + " không thuận lợi để chụp ảnh";
        }
        System.out.println("Probability of photoshoot:"+d1);
        System.out.println("No chance of photoshoot:"+d2);
        System.out.println(str);
        return str;
    }
}
