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
 	try {
                String encoding="GBK";
                File file=new File("/home/lining/data/order.txt");
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
                File file=new File("/home/lining/data/user.txt");
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
	int o_size = order.size();
	int u_size = user.size();

		String[] order_col1=new String[o_size];
		String[] order_col2=new String[o_size];

		String[] user_col1=new String[u_size];
		String[] user_col2=new String[u_size];
		
		for(int i=0;i<o_size;i++)
		{
			String [] tmp=order.get(i).split("[|]");
			order_col1[i]=tmp[0];
			
			order_col2[i]=tmp[2];

		}
		for(int j=0;j<u_size;j++)
		{
			String [] tmp1=user.get(j).split("[|]");
			user_col1[j]=tmp1[0];
			
			user_col2[j]=tmp1[2];
			
		}
		System.out.println(o_size);
		System.out.println(u_size);
		String[] result = get_result(order_col1,order_col2, user_col1, user_col2, o_size,u_size);
		
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
		writer.write("NULL");
                writer.newLine();//换行
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
		
		System.load("/home/lining/libjnidll.so");
	}
}
