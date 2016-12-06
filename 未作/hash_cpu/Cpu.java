import java.util.*;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.text.SimpleDateFormat;
public class Cpu {
public static native String[] get_result(String[] ocol1,String[] ocol2,String[] ucol1,String[] ucol2,int o_size,int u_size);
public static void main(String[] args)
{
	System.out.println(new SimpleDateFormat("yyyyMMddHHmmssSSS") .format(new Date() ));
	ArrayList<String> order = new ArrayList<String>();
	ArrayList<String> user = new ArrayList<String>();
	ArrayList<String> order1 = new ArrayList<String>();
	ArrayList<String> user1 = new ArrayList<String>();
	System.out.println("duquorder");
 	try {
                String encoding="GBK";
                File file=new File("/home/lining/data/order1.txt");
                if(file.isFile() && file.exists()){ //判断文件是否存在
                    InputStreamReader read = new InputStreamReader(
                    new FileInputStream(file),encoding);//考虑到编码格式
                    BufferedReader bufferedReader = new BufferedReader(read);
                    String lineTxt = null;
                    while((lineTxt = bufferedReader.readLine()) != null){
                        order.add(lineTxt);
                    }
                    read.close();
        }else{
            System.out.println("找不到指定的文件");
        }
        } catch (Exception e) {
            System.out.println("读取文件内容出错");
            e.printStackTrace();
        }
try {
                String encoding="GBK";
                File file=new File("/home/lining/data/order2.txt");
                if(file.isFile() && file.exists()){ //判断文件是否存在
                    InputStreamReader read = new InputStreamReader(
                    new FileInputStream(file),encoding);//考虑到编码格式
                    BufferedReader bufferedReader = new BufferedReader(read);
                    String lineTxt = null;
                    while((lineTxt = bufferedReader.readLine()) != null){
                        order1.add(lineTxt);
                    }
                    read.close();
        }else{
            System.out.println("找不到指定的文件");
        }
        } catch (Exception e) {
            System.out.println("读取文件内容出错");
            e.printStackTrace();
        }
	System.out.println("duwanorder");
	System.out.println("duquuser");
 	try {
                String encoding="GBK";
                File file=new File("/home/lining/data/user1.txt");
                if(file.isFile() && file.exists()){ //判断文件是否存在
                    InputStreamReader read = new InputStreamReader(
                    new FileInputStream(file),encoding);//考虑到编码格式
                    BufferedReader bufferedReader = new BufferedReader(read);
                    String lineTxt = null;
                    while((lineTxt = bufferedReader.readLine()) != null){
                        user.add(lineTxt);
                    }
                    read.close();
        }else{
            System.out.println("找不到指定的文件");
        }
        } catch (Exception e) {
            System.out.println("读取文件内容出错");
            e.printStackTrace();
        }
try {
                String encoding="GBK";
                File file=new File("/home/lining/data/user2.txt");
                if(file.isFile() && file.exists()){ //判断文件是否存在
                    InputStreamReader read = new InputStreamReader(
                    new FileInputStream(file),encoding);//考虑到编码格式
                    BufferedReader bufferedReader = new BufferedReader(read);
                    String lineTxt = null;
                    while((lineTxt = bufferedReader.readLine()) != null){
                        user1.add(lineTxt);
                    }
                    read.close();
        }else{
            System.out.println("找不到指定的文件");
        }
        } catch (Exception e) {
            System.out.println("读取文件内容出错");
            e.printStackTrace();
        }
	System.out.println("duwanuser");
	
	int o_size = order.size();
	int u_size = user.size();
	int o_size1 = order1.size();
	int u_size1 = user1.size();
	System.out.println(o_size+o_size1);
	System.out.println(u_size+u_size1);
	
		String[] order_col1=new String[o_size+o_size1];
		String[] order_col2=new String[o_size+o_size1];

		String[] user_col1=new String[u_size+u_size1];
		String[] user_col2=new String[u_size+u_size1];
		System.out.println("fengeshuju");
		for(int i=0;i<o_size;i++)
		{
			if(i%500000==0)
			{
				//System.gc();
			System.out.println(i);
			}
			String [] tmp=order.get(i).split("[|]");
			order_col1[i]=tmp[0];
			
			order_col2[i]=tmp[2];
			
		}
		System.gc();
		for(int i=0;i<o_size1;i++)
		{
			if(i%500000==0)
			{
				//System.gc();
			System.out.println(i);
			}
			String [] tmp=order1.get(i).split("[|]");
			order_col1[i+o_size]=tmp[0];
			
			order_col2[i+o_size]=tmp[2];
			
		}
		System.gc();
		System.out.println("fengeyiban");
		for(int j=0;j<u_size;j++)
		{
				if(j%500000==0)
			{
				//System.gc();
			System.out.println(j);
			}
			String [] tmp1=user.get(j).split("[|]");
			user_col1[j]=tmp1[0];
			
			user_col2[j]=tmp1[2];
			
			
		}
		System.gc();
		for(int j=0;j<u_size1;j++)
		{
				if(j%500000==0)
			{
				//System.gc();
			System.out.println(j);
			}
			String [] tmp1=user1.get(j).split("[|]");
			user_col1[j+u_size]=tmp1[0];
			
			user_col2[j+u_size]=tmp1[2];
			
			
		}
		System.gc();
		System.out.println("fengewancheng");
		System.out.println("kashichuli");
		String[] result = get_result(order_col1,order_col2, user_col1, user_col2, o_size+o_size1,u_size+u_size1);
		System.out.println("chulijieshu");
		       File file = new File("/home/lining/data/result.txt");
        FileWriter fw = null;
        BufferedWriter writer = null;
        try {
            fw = new FileWriter(file);
            writer = new BufferedWriter(fw);
             if(result==null)
	    {
		writer.write("empty");
	    }
	    else
	{
            for(int i=0;i<result.length;i++){
			if(result[i]==null)
	{
		continue;
	}
	else
{
                writer.write(result[i]);
                writer.newLine();//换行
} 
           }
	}
            writer.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }catch (IOException e) {
            e.printStackTrace();
        }finally{
            try {
                writer.close();
                fw.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
	System.out.println(new SimpleDateFormat("yyyyMMddHHmmssSSS") .format(new Date() ));

}
	static{
		
		System.load("/home/lining/data/libjnidll.so");
	}
}
