using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using Ahnduino.Lib;
using Ahnduino.Lib.Object;
using Google.Cloud.Firestore;

namespace Ahnduino.Wins
{
	/// <summary>
	/// FixHoldMenu.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class FixHoldMenu : Window
	{
		string uid;

		FixHold? fixHold = null;

		ObservableCollection<Request> userlist = new ObservableCollection<Request>();
		ObservableCollection<Request> roomoutlist = new ObservableCollection<Request>();
		//ObservableCollection<string> datelist = new ObservableCollection<string>();
		//ObservableCollection<string> requestlist = new ObservableCollection<string>();

		//string? selectedEmail = null;
		//string? selectedDate = null;

		public FixHoldMenu(string uid)
		{
			this.uid = uid;
			InitializeComponent();

			DateTime dateTime = DateTime.Now;

			RequestUserListView.ItemsSource = Fbad.GetFixHoldList();

			//RequestUserListView.ItemsSource = userlist;
			//RequestDateListView.ItemsSource = datelist;
			//RequestListView.ItemsSource = requestlist;
			//Fbad.GetRequestUserList(userlist);
		}

		private void RequestUserListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			fixHold = RequestUserListView.SelectedItem as FixHold;
			if (fixHold != null)
			{
				Timestamp temp = (Timestamp)fixHold.fixholdtime!;
				DateTime dateTime = temp.ToDateTime();
				labeltitle.Text = "문서ID		: " + fixHold.DocID + "\r\n" +
					"현장직 이름	: " + fixHold.worker + "\r\n" +
					"날짜		: " + fixHold.Date + "\r\n" +
					"제목		: " + fixHold.Title + "\r\n" +
					"내용		: " + fixHold.Text + "\r\n" +
					"사용자 UID	: " + fixHold.UID + "\r\n" +
					"예약된 시간	: " + fixHold.reserv + "\r\n" +
					"주소		: " + fixHold.주소 + "\r\n" +
					"건물명		: " + fixHold.건물명 + "\r\n" +
					"보류 텍스트	: " + fixHold.fixholdtext + "\r\n" +
					"보류 시간		: " + dateTime.ToString() + "\r\n";
			}

		}

		private void LoginBtn_Click(object sender, RoutedEventArgs e)
		{
			if (fixHold != null)
			{
				Fbad.RemoveFixHold(fixHold.worker!, fixHold.DocID!);
			}

			MessageBox.Show("처리완료 되었습니다");

			RequestUserListView.ItemsSource = Fbad.GetFixHoldList();
		}

		private void Build_Click(object sender, RoutedEventArgs e)
		{
			BuildMenu build = new();
			build.Show();
		}

		#region Sidemenu
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
