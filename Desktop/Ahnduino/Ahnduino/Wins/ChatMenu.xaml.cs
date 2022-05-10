using System;
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
using Ahnduino.Lib;
using Ahnduino.Lib.Object;

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
		string? email;
		string? uid;

		public ChatMenu()
		{
			InitializeComponent();
			Firebase.GetChatUserList(chatuserlist);

			ChatListView.ItemsSource = chatlist;
			chatneedanswerlistview.ItemsSource = chatuserlist;
		}

		private void Button_Click(object sender, RoutedEventArgs e)
		{
			Firebase.GetChat(null, chatlist, SV);
			email = textboxemail.Text;
			Firebase.FirstGetChatList(email, chatlist);
			if(chatlist.Count > 0)
				chatlist.RemoveAt(chatlist.Count - 1);
			Firebase.GetChat(email, chatlist, SV);
			SV.ScrollToBottom();


			Console.WriteLine(chatlist.Count);
		}

		private void sendbutton_Click(object sender, RoutedEventArgs e)
		{
			uid = "관리자@이메일.컴";
			Firebase.SendChat(email!, uid, chattextbox.Text);
			SV.ScrollToBottom();
		}

		private void ScrollViewer_ScrollChanged(object sender, ScrollChangedEventArgs e)
		{
			if (SV.VerticalOffset == 0 && ChatListView.Items.Count > 0)
			{
				Firebase.GetChatList(email!, chatlist);
			}
		}

		private void chatneedanswerlistview_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			Firebase.GetChat(null, chatlist, SV);
			email = chatneedanswerlistview.SelectedItem.ToString();
			Firebase.FirstGetChatList(email!, chatlist);
			if (chatlist.Count > 0)
				chatlist.RemoveAt(chatlist.Count - 1);
			Firebase.GetChat(email, chatlist, SV);
			SV.ScrollToBottom();
		}
	}
}
