using System;
using System.IO;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
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
using Firebase.Storage;
using Ahnduino.Lib;
using Ahnduino.Lib.Object;
using Microsoft.Win32;
using System.Threading;

#pragma warning disable CS8622 // 매개 변수 형식에서 참조 형식의 Null 허용 여부가 대상 대리자와 일치하지 않습니다(Null 허용 여부 특성 때문일 수 있음).

namespace Ahnduino.Wins
{
	/// <summary>
	/// ChatMenu.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class ChatMenu : Window
	{
		ObservableCollection<Chat> chatlist = new();
		ObservableCollection<string> chatuserlist = new();
		ObservableCollection<string> chatresentuserlist = new();
		string? email;
		string uid;
		bool refresh = true;
		bool firstload = true;

		public ChatMenu(string uid)
		{
			this.uid = uid;

			InitializeComponent();
			

			ChatListView.ItemsSource = chatlist;
			chatneedanswerlistview.ItemsSource = chatuserlist;
			Fbad.GetChatUserList(chatuserlist);
			Fbad.ChatGetResentList(uid, chatresentuserlist);
		}

		private void Button_Click(object sender, RoutedEventArgs e)
		{
			Fbad.GetChat(null, uid, chatlist, chatresentuserlist, SV);
			email = Fbad.AddressToEmail(textboxemail.Text);
			Fbad.FirstGetChatList(email, chatlist);
			if(chatlist.Count > 0)
				chatlist.RemoveAt(chatlist.Count - 1);
			Fbad.GetChat(email, uid, chatlist, chatresentuserlist, SV);
			SV.ScrollToBottom();
		}

		private void textboxemail_GotFocus(object sender, RoutedEventArgs e)
		{
			try
			{
				textboxemail.Text = Fbad.GetFA();
				Button_Click(sender, e);
			}
			catch (Exception)
			{}
			
		}

		private void sendbutton_Click(object sender, RoutedEventArgs e)
		{
			Fbad.SendChat(email!, uid, chattextbox.Text);
			SV.ScrollToBottom();

			chattextbox.Text = "";
		}

		private void ScrollViewer_ScrollChanged(object sender, ScrollChangedEventArgs e)
		{
			if (SV.VerticalOffset == 0 && ChatListView.Items.Count > 0 && refresh)
			{
				refresh = false;
				Console.WriteLine("svcalled");
				Fbad.GetChatList(email!, chatlist);
				if(firstload)
				{
					firstload = false;
				}
				else
				{
					SV.ScrollToVerticalOffset(10);
				}
				ChatListView.ItemsSource = null;
				ChatListView.ItemsSource = chatlist;
			}
			else if(SV.VerticalOffset > 10 )
			{
				refresh = true;
			}
		}

		private void chatneedanswerlistview_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			if(chatneedanswerlistview.SelectedItem != null)
			{
				Fbad.GetChat(null, uid, chatlist, chatresentuserlist, SV);
				email = Fbad.getEmail(chatneedanswerlistview!.SelectedItem!.ToString()!);
				Fbad.FirstGetChatList(email!, chatlist);
				if (chatlist.Count > 0)
					chatlist.RemoveAt(chatlist.Count - 1);
				Fbad.GetChat(email, uid, chatlist, chatresentuserlist, SV);
				SV.ScrollToBottom();
			}
			
		}

		private void buploadimg_Click(object sender, RoutedEventArgs e)
		{
			OpenFileDialog openFileDialog = new OpenFileDialog();
			openFileDialog.Multiselect = true;

			if (openFileDialog.ShowDialog() == true)
			{
				Fbad.SendImg(email!, uid, openFileDialog.FileNames);
			}
		}

		private void chattextbox_KeyDown(object sender, KeyEventArgs e)
		{
			if(e.Key == Key.Enter)
			{
				sendbutton_Click(sender, e);
			}
		}

		private void ChatListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			Chat chat = (Chat)ChatListView.SelectedItem;
			Console.WriteLine(chat.date);
			Console.WriteLine(chat.isfirst);
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

		private void bread_Click(object sender, RoutedEventArgs e)
		{
			chatneedanswerlistview.ItemsSource = chatresentuserlist;
		}

		private void bnoread_Click(object sender, RoutedEventArgs e)
		{
			chatneedanswerlistview.ItemsSource = chatuserlist;
		}

		private void Window_Closed(object sender, EventArgs e)
		{
			Fbad.ChatSetResentList(uid, chatresentuserlist);
		}
	}
}
