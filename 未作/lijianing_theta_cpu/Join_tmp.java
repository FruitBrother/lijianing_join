
import java.util.*;

import java.text.SimpleDateFormat;


public class Join_tmp {
	
	public static int trans_data(ArrayList<String> o_data,ArrayList<String> u_data,int o_size,int u_size)
	{

		//ArrayList<String> re = new ArrayList<String>();
		//String res=null;
		int count=0;
		
		for(int i=0;i<o_size;i++)
			for(int j=0;j<u_size;j++)
			{
				String [] tmp=o_data.get(i).split("[|]");
				String [] tmp1=u_data.get(j).split("[|]");
				int orderkey = Integer.parseInt(tmp[1]);
				int userkey = Integer.parseInt(tmp1[1]);
				if(orderkey<userkey)
				{
					//res=tmp[1]+","+tmp1[1]+","+tmp[3]+","+tmp1[3];
					//re.add(res);
					count++;
				}

			}
		
		//String[] result = new String[re.size()];
		
		
		//re.toArray(result);
		//String[] result1 = new String[]{"aaaa","bbbb"};
		
		return count;
		
	}

}
