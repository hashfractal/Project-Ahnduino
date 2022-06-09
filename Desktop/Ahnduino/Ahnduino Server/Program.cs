using System.Timers;

class Program
{
	static void Main(string[] args)
	{
		System.Timers.Timer timer = new System.Timers.Timer();
		timer.Interval = 1000 * 10 * 60 * 24; // 24시간마다 오늘 날짜 체크
		timer.Elapsed += new ElapsedEventHandler(timer_Elapsed!);
		timer.Start();

		while(true)
		{
			Console.WriteLine("1: 고지서 일괄 발송");
			string input = Console.ReadLine()!;
			if (input == "1")
				Fbad.UpdateAllBill();
			else if (input == "stop")
				break;
		}
	}
	static void timer_Elapsed(object sender, ElapsedEventArgs e)
	{
		if(DateTime.Now.Day == 20)
			Fbad.UpdateAllBill();
	}
}