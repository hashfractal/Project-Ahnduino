using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Threading;
using System.ComponentModel;

namespace Ahnduino.Wins
{
	/// <summary>
	/// SignIn.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class SignIn : Window
	{
		public SignIn()
		{

			SoundPlayer player = new SoundPlayer("SOund/Intro.wav");
			player.LoadCompleted += delegate (object? sender, AsyncCompletedEventArgs e)
			{
				player.Play();
			};
			player.LoadAsync();
		}

		private void Login_Btn_Click(object sender, RoutedEventArgs e)
		{

		}

		private void Register_Btn_Click(object sender, RoutedEventArgs e)
		{

		}

		private void Window_Loaded(object sender, RoutedEventArgs e)
		{
			
		}
	}
}
