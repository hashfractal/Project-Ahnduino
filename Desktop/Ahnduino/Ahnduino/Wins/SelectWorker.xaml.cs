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
	/// SelectWorker.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class SelectWorker : Window
	{
		public SelectWorker()
		{
			InitializeComponent();
			Fbad.SetWorkerComboBox(cbregion, cbgu, cbdong);
		}

		private void bselectemail_Click(object sender, RoutedEventArgs e)
		{
			lbworker.ItemsSource = null;
			lbworker.Items.Add(Fbad.WorkerGet(tbemail.Text));
		}

		private void cbdong_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			
			if (cbregion.Text != "" && cbgu.Text != "")
			{
				lbworker.Items.Clear();
				lbworker.ItemsSource = Fbad.WorkerGetList(cbregion.Text, cbgu.Text, cbdong.SelectedItem.ToString()!);
			}
		}
	}
}
