
import java.util.*;

import java.text.SimpleDateFormat;


public class Join_tmp {
	
	public static String[] trans_data(ArrayList<String> o_data,ArrayList<String> u_data,int o_size,int u_size)
	{

		ArrayList<String> re = new ArrayList<String>();
		String res=null;
		
		
		for(int i=0;i<o_size;i++)
			for(int j=0;j<u_size;j++)
			{
				String [] tmp=o_data.get(i).split("[|]");
				String [] tmp1=u_data.get(j).split("[|]");
				
				if(tmp[1].equals(tmp1[1]))
				{
					res=tmp[1]+","+tmp1[1]+","+tmp[3]+","+tmp1[3];
					re.add(res);
				}

			}
		
		String[] result = new String[re.size()];
		
		
		re.toArray(result);
		//String[] result1 = new String[]{"aaaa","bbbb"};
		
		return result;
		
	}

}
