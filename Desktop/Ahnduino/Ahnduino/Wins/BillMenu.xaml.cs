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
		string uid;

		ObservableCollection<Bill> billlist = new ObservableCollection<Bill>();
		Bill? bill;
		Bill? newbill = new();

		public BillMenu(string uid)
		{
			this.uid = uid;

			InitializeComponent();


			billlist.CollectionChanged += new System.Collections.Specialized.NotifyCollectionChangedEventHandler(CollectionChangedMethod!);

			billlistbox.ItemsSource = billlist;
			Fbad.GetneedListbox(lbneedsomething);
			//billlistview.ItemsSource = billlist;
		}

		private void CollectionChangedMethod(object sender, NotifyCollectionChangedEventArgs e)
		{
			billlistbox.SelectedIndex = billlist.Count > 0 ? billlist.Count - 1 : 0;
		}

		private void searchbutton_Click(object sender, RoutedEventArgs e)	
		{
			Thread.Sleep(200);
			
			Fbad.GetBillList(Fbad.getEmail(textboxemail.Text), billlist);
			Fbad.SetNewBill(Fbad.getEmail(textboxemail.Text), newbill!);

			if (newbill!.Totmoney == null)
			{
				DateTime dt = DateTime.Now;
				tbtitle.Text = dt.Month .ToString() + "월 고지서 추가";
				ntb1.Text = dt.Year.ToString();
				ntb2.Text = dt.Month.ToString();
				
				ntb4.Text = dt.AddMonths(1).Month.ToString();
				ntb6.Text = newbill.Money.ToString();
				ntb8.Text = newbill.Arrears.ToString();
				ntb7.Text = "0";
			}
			else
			{
				Timestamp timestamp = (Timestamp)newbill.Nab!;
				DateTime dt = timestamp.ToDateTime();
				dt = dt.AddHours(9);

				tbtitle.Text = dt.Month.ToString() + "월 고지서 추가";
				ntb1.Text = dt.Year.ToString();
				ntb2.Text = dt.Month.ToString();
				ntb3.Text = newbill.Totmoney.ToString();
				ntb4.Text = dt.AddMonths(1).Month.ToString();
				ntb4_1.Text = 20.ToString();//dt.Day.ToString(); 
				ntb5.Text = newbill.Totmoney.ToString();
				ntb6.Text = newbill.Money.ToString();
				ntb7.Text = newbill.Defmoney.ToString();
				ntb8.Text = newbill.Arrears.ToString();
				ntb9.Text = newbill.Pomoney.ToString();
				ntb10.Text = newbill.Repair.ToString();
			}
		}

		private void textboxemail_GotFocus(object sender, RoutedEventArgs e)
		{
			try
			{
				textboxemail.Text = Fbad.GetFA();
				searchbutton_Click(sender, e);
			}
			catch (Exception)
			{ }
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
			Fbad.AcceptPay(Fbad.getEmail(textboxemail.Text), bill!);
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

			Fbad.CreateBill(Fbad.getEmail(textboxemail.Text), newbill!, billlist.Count);
			searchbutton_Click(sender, e);
		}

		private void ntb6_TextChanged(object sender, TextChangedEventArgs e)
		{
			int n = 0;
			int n2 = 0;
			if (ntb6.Text != "")
				n += int.Parse(ntb6.Text);
			if (ntb7.Text != "")
				n += int.Parse(ntb7.Text);
			if (ntb10.Text != "")
				n += int.Parse(ntb10.Text);

			if (ntb8.Text != "")
				n2 = int.Parse(ntb8.Text) + n;

			ntb5.Text = n.ToString();
			ntb3.Text = n.ToString();
			ntb9.Text = n2.ToString();
		}

		private void ntb7_TextChanged(object sender, TextChangedEventArgs e)
		{
			int n = 0;
			int n2 = 0;
			if (ntb6.Text != "")
				n += int.Parse(ntb6.Text);
			if (ntb7.Text != "")
				n += int.Parse(ntb7.Text);
			if (ntb10.Text != "")
				n += int.Parse(ntb10.Text);

			if (ntb8.Text != "")
				n2 = int.Parse(ntb8.Text) + n;

			ntb5.Text = n.ToString();
			ntb3.Text = n.ToString();
			ntb9.Text = n2.ToString();
		}

		private void ntb8_TextChanged(object sender, TextChangedEventArgs e)
		{
			int n = 0;
			int n2 = 0;
			if (ntb6.Text != "")
				n += int.Parse(ntb6.Text);
			if (ntb7.Text != "")
				n += int.Parse(ntb7.Text);
			if (ntb10.Text != "")
				n += int.Parse(ntb10.Text);

			if (ntb8.Text != "")
				n2 = int.Parse(ntb8.Text) + n;

			ntb5.Text = n.ToString();
			ntb3.Text = n.ToString();
			ntb9.Text = n2.ToString();
		}

		private void ntb10_TextChanged(object sender, TextChangedEventArgs e)
		{
			int n = 0;
			int n2 = 0;
			if (ntb6.Text != "")
				n += int.Parse(ntb6.Text);
			if (ntb7.Text != "")
				n += int.Parse(ntb7.Text);
			if (ntb10.Text != "")
				n += int.Parse(ntb10.Text);

			if (ntb8.Text != "")
				n2 = int.Parse(ntb8.Text) + n;

			ntb5.Text = n.ToString();
			ntb3.Text = n.ToString();
			ntb9.Text = n2.ToString();
		}

		private void lbneedsomething_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			textboxemail.Text = (string)lbneedsomething.SelectedItem;
			searchbutton_Click(sender, e);
		}

		#region Sidemenu
		private void Worker_Click(object sender, RoutedEventArgs e)
		{
			SelectWorker selectWorker = new();
			selectWorker.Show();
		}

		private void gotorequest_Click(object sender, RoutedEventArgs e)
		{
			RequestMenu menu = new(uid);
			menu.Show();
			Close();
		}
		private void Build_Click(object sender, RoutedEventArgs e)
		{
			BuildMenu build = new();
			build.Show();
		}
		private void gotochat_Click(object sender, RoutedEventArgs e)
		{
			ChatMenu menu = new(uid);
			menu.Show();
			Close();
		}

		private void gotoboard_Click(object sender, RoutedEventArgs e)
		{
			BoardMenu menu = new(uid);
			menu.Show();
			Close();
		}

		private void gotobill_Click(object sender, RoutedEventArgs e)
		{
			BillMenu menu = new(uid);
			menu.Show();
			Close();
		}

		private void gotogallery_Click(object sender, RoutedEventArgs e)
		{
			InfoMenu menu = new(uid);
			menu.Show();
			Close();
		}

		private void Fixhold_Click(object sender, RoutedEventArgs e)
		{
			FixHoldMenu menu = new(uid);
			menu.Show();
			Close();
		}

		#endregion


	}
}
