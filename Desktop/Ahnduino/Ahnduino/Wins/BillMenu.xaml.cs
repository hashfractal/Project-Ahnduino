using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Threading;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using Google.Cloud.Firestore;
using Ahnduino.Lib;
using Ahnduino.Lib.Object;

namespace Ahnduino.Wins
{
	/// <summary>
	/// BillMenu.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class BillMenu : Window
	{
		ObservableCollection<Bill> billlist = new ObservableCollection<Bill>();
		Bill? bill;
		Bill? newbill = new();

		public BillMenu()
		{
			InitializeComponent();

			billlist.CollectionChanged += new System.Collections.Specialized.NotifyCollectionChangedEventHandler(CollectionChangedMethod!);

			billlistbox.ItemsSource = billlist;
			//billlistview.ItemsSource = billlist;
		}

		private void CollectionChangedMethod(object sender, NotifyCollectionChangedEventArgs e)
		{
			billlistbox.SelectedIndex = billlist.Count > 0 ? billlist.Count - 1 : 0;
		}

		private void searchbutton_Click(object sender, RoutedEventArgs e)	
		{
			Thread.Sleep(200);
			
			Firebase.GetBillList(textboxemail.Text, billlist);
			Firebase.SetNewBill(textboxemail.Text, newbill!);

			if (newbill!.Totmoney == null)
			{
				DateTime dt = DateTime.Now;
				tbtitle.Text = dt.AddMonths(-1).Month .ToString() + "월 고지서 추가";
				ntb1.Text = dt.AddMonths(-1).Year.ToString();
				ntb2.Text = dt.AddMonths(-1).Month.ToString();
				ntb4.Text = dt.AddMonths(1).Month.ToString();
				ntb7.Text = "0";
			}
			else
			{
				Timestamp timestamp = (Timestamp)newbill.Nab!;
				DateTime dt = timestamp.ToDateTime();
				dt = dt.AddHours(9);

				tbtitle.Text = dt.AddMonths(-1).Month.ToString() + "월 고지서 추가";
				ntb1.Text = dt.AddMonths(-1).Year.ToString();
				ntb2.Text = dt.AddMonths(-1).Month.ToString();
				ntb3.Text = newbill.Totmoney.ToString();
				ntb4.Text = dt.Month.ToString();
				ntb4_1.Text = dt.Day.ToString();
				ntb5.Text = newbill.Totmoney.ToString();
				ntb6.Text = newbill.Money.ToString();
				ntb7.Text = newbill.Defmoney.ToString();
				ntb8.Text = newbill.Arrears.ToString();
				ntb9.Text = newbill.Pomoney.ToString();
				ntb10.Text = newbill.Repair.ToString();
			}
		}

		private void billlistbox_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			bill = billlistbox.SelectedItem as Bill;

			if(bill != null)
			{
				Timestamp temp = (Timestamp)bill!.Nab!;
				DateTime dt = temp.ToDateTime();
				dt = dt.AddHours(9);

				labeldate.Content = dt.Year.ToString() + "년 " + (dt.Month - 1 == 0 ? 12 : dt.Month - 1).ToString() + "월분";
				tbpay.Text = (bool)bill!.Pay! ? "완납" : "미납";
				labeltotalmoney.Content = bill.Totmoney.ToString() + "원";
				labeldeadline.Content = "납부마감일 " + dt.Month.ToString() + "월 " + dt.Day.ToString() + "일";
				tbtotalmoney.Text = bill.Totmoney.ToString();
				tbi1.Text = bill!.Money.ToString();
				tbi2.Text = bill!.Defmoney.ToString();
				tbi3.Text = bill!.Arrears.ToString();
				tbi4.Text = bill!.Pomoney.ToString();
				tbi5.Text = bill!.Repair.ToString();
				if (bill!.Ab == 1)
					tbstatus.Text = "완납";
				else if (bill!.Ab == 2)
					tbstatus.Text = "미납";
				else if (bill!.Ab == 3)
					tbstatus.Text = "연체";
			}
		}

		private void acceptbutton_Click(object sender, RoutedEventArgs e)
		{
			bill = billlistbox.SelectedItem as Bill;
			Firebase.AcceptPay(textboxemail.Text, bill!);
			searchbutton_Click(sender, e);
		}

		private void ntbstatus_Click(object sender, RoutedEventArgs e)
		{
			newbill!.Arrears = int.Parse(ntb8.Text);
			newbill.Defmoney = int.Parse(ntb7.Text);
			newbill.Money = int.Parse(ntb6.Text);
			DateTime dt = new DateTime(int.Parse(ntb1.Text), int.Parse(ntb2.Text), int.Parse(ntb4_1.Text));
			dt = dt.AddMonths(1);
			newbill.Nab = Timestamp.FromDateTime(dt.ToUniversalTime());
			newbill.Pomoney = int.Parse(ntb9.Text);
			newbill.Repair = int.Parse(ntb10.Text);
			newbill.Totmoney = int.Parse(ntb3.Text);

			Firebase.CreateBill(textboxemail.Text, newbill!, billlist.Count);
			searchbutton_Click(sender, e);
		}

	}
}
