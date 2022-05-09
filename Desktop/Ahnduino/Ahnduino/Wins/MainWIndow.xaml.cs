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
using Google.Cloud.Firestore;
using Ahnduino.Lib;
using Ahnduino.Lib.Object;

namespace Ahnduino.Wins
{
	/// <summary>
	/// MainWIndow.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class MainWindow : Window
	{
		Request? request = null;
		string UID;

		ObservableCollection<string> userlist = new ObservableCollection<string>();
		ObservableCollection<string> datelist = new ObservableCollection<string>();
		ObservableCollection<string> requestlist = new ObservableCollection<string>();

		string? selectedEmail = null;
		string? selectedDate = null;

		public MainWindow(string UID)
		{
			InitializeComponent();
			this.UID = UID;

			RequestUserListView.ItemsSource = userlist;
			RequestDateListView.ItemsSource = datelist;
			RequestListView.ItemsSource = requestlist;
			Firebase.GetRequestUserList(userlist);
		}

		private void RequestUserListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			selectedEmail = (string)RequestUserListView.SelectedItem;
			Firebase.GetDateList(null, datelist);
			Firebase.GetDateList(selectedEmail, datelist);
		}

		private void RequestDateListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			selectedDate = (string)RequestDateListView.SelectedItem;
			Firebase.GetRequestList(null, null, requestlist);
			Firebase.GetRequestList(selectedEmail, selectedDate, requestlist);
		}

		private void RequestListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			Imagelist.Children.Clear();
			request = Firebase.GetRequest(selectedEmail, selectedDate, (string)RequestListView.SelectedItem);

			foreach(string i in request!.Images!)
			{
				Image image = new Image();

				BitmapImage bitmap = new BitmapImage();
				bitmap.BeginInit();
				bitmap.UriSource = new Uri(@i, UriKind.Absolute);
				bitmap.EndInit();

				image.Source = bitmap;
				Imagelist.Children.Add(image);

				
			}
			labeltitle.Text = request.Title;
			labelinfo.Text = request.UID;
			labeltext.Content = request.Text;
		}

		private void LoginBtn_Click(object sender, RoutedEventArgs e)
		{
			if(request != null)
			{
				request.Reserve = TextBoxYear.Text + "-" + TextBoxMonth.Text + "-" + TextBoxDay.Text;
				request.Isreserve = true;
				Firebase.UpdateRequest(selectedEmail, selectedDate, (string)RequestListView.SelectedItem, request!, UID);
			}

			MessageBox.Show("예약완료되었습니다");
		}
	}
}
