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
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using Ahnduino.Lib;

namespace Ahnduino.Wins
{
	/// <summary>
	/// AddBuild.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class AddBuild : Window
	{
		public AddBuild()
		{
			InitializeComponent();
		}

		private void RegBtn_Click(object sender, RoutedEventArgs e)
		{
			string exec = Fbad.validationBuild(tbaddress.Text, tbbuild.Text, tbid.Text);
			if( exec != "")
			{
				MessageBox.Show(exec);
				return;
			}
			Fbad.AddBuild(tbaddress.Text, tbbuild.Text, tbid.Text, int.Parse(tbpay.Text), int.Parse(tbunpay.Text));
			MessageBox.Show("건물이 등록되었습니다");
			Close();
		}
	}
}
