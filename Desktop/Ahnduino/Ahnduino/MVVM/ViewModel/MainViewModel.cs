using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Ahnduino.Core;
using Ahnduino.MVVM.Model;

namespace Ahnduino.MVVM.ViewModel
{
	internal class MainViewModel : ObservableObject
	{
		public ObservableCollection<MessageModel>? Messages { get; set; }
		public ObservableCollection<ContactModel>? Contacts { get; set; }

		#region Commands
		public RelayCommand SendCommand { get; set; }

		private ContactModel? _selectedContact;

		public ContactModel SelectedContact
		{
			get { return _selectedContact!; }
			set
			{ 
				_selectedContact = value;
				OnPropertyChanged();
			}
			
		}


		private string? _message;

		public string Message
		{
			get { return _message!; }
			set {
				_message = value; 
				OnPropertyChanged();
			}
		}
		#endregion

		public MainViewModel()
		{
			Messages = new ObservableCollection<MessageModel>();
			Contacts = new ObservableCollection<ContactModel>();

			SendCommand = new RelayCommand(o =>
			{
				Messages.Add(new MessageModel
				{
					Message = Message,
					FirstMessage = false
				});

				Message = null!;
			});

			Messages.Add(new MessageModel
			{
				UserName = "Allison",
				UserNameColor = "#409aff",
				ImageSource = "https://i.imgur.com/zEsbclE.jpeg",
				Message = "Flawless",
				Time = DateTime.Now,
				IsNativeOrigin = false,
				FirstMessage = true
			});

			for (int i = 0; i < 3; i++)
			{
				Messages.Add(new MessageModel
				{
					UserName = "Allison",
					UserNameColor = "#409aff",
					ImageSource = "https://i.imgur.com/zEsbclE.jpeg",
					Message = "Perfect",
					Time = DateTime.Now,
					IsNativeOrigin = false,
				});
			}

			for (int i = 0; i < 4; i++)
			{
				Messages.Add(new MessageModel
				{
					UserName = "Bunny",
					UserNameColor = "#409aff",
					ImageSource = "https://i.imgur.com/zEsbclE.jpeg",
					Message = "lastss",
					Time = DateTime.Now,
					IsNativeOrigin = true,
				});
			}

			Messages.Add(new MessageModel
			{
				UserName = "Bunny",
				UserNameColor = "#409aff",
				ImageSource = "https://i.imgur.com/zEsbclE.jpeg",
				Message = "lastss",
				Time = DateTime.Now,
				IsNativeOrigin = true,
			});

			for (int i = 0; i < 5; i++)
			{
				Contacts.Add(new ContactModel
				{
					UserName = $"Allison {i}",
					ImageSource = "https://i.imgur.com/zEsbclE.jpeg",
					Messages = Messages
				});
			}
		}
	}
}
