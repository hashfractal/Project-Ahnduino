﻿#pragma checksum "..\..\..\..\Wins\Auth.xaml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "9CB8D2B77A05D4EC1FA5FCE45F15BDB85C2A55D9"
//------------------------------------------------------------------------------
// <auto-generated>
//     이 코드는 도구를 사용하여 생성되었습니다.
//     런타임 버전:4.0.30319.42000
//
//     파일 내용을 변경하면 잘못된 동작이 발생할 수 있으며, 코드를 다시 생성하면
//     이러한 변경 내용이 손실됩니다.
// </auto-generated>
//------------------------------------------------------------------------------

using Ahnduino.Wins;
using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Controls.Ribbon;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Media.TextFormatting;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Shell;


namespace Ahnduino.Wins {
    
    
    /// <summary>
    /// Auth
    /// </summary>
    public partial class Auth : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
        #line 19 "..\..\..\..\Wins\Auth.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Image ___Image_mainIConcolor_png;
        
        #line default
        #line hidden
        
        
        #line 35 "..\..\..\..\Wins\Auth.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox IDTextbox;
        
        #line default
        #line hidden
        
        
        #line 60 "..\..\..\..\Wins\Auth.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox PWTextbox;
        
        #line default
        #line hidden
        
        
        #line 82 "..\..\..\..\Wins\Auth.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button LoginBtn;
        
        #line default
        #line hidden
        
        
        #line 98 "..\..\..\..\Wins\Auth.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button RegisterBtn;
        
        #line default
        #line hidden
        
        
        #line 100 "..\..\..\..\Wins\Auth.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button ResetPwBtn;
        
        #line default
        #line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "6.0.4.0")]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/Ahnduino;component/wins/auth.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\..\..\Wins\Auth.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
            #line default
            #line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "6.0.4.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            this.___Image_mainIConcolor_png = ((System.Windows.Controls.Image)(target));
            return;
            case 2:
            this.IDTextbox = ((System.Windows.Controls.TextBox)(target));
            return;
            case 3:
            this.PWTextbox = ((System.Windows.Controls.TextBox)(target));
            
            #line 60 "..\..\..\..\Wins\Auth.xaml"
            this.PWTextbox.KeyDown += new System.Windows.Input.KeyEventHandler(this.PWTextbox_KeyDown);
            
            #line default
            #line hidden
            
            #line 60 "..\..\..\..\Wins\Auth.xaml"
            this.PWTextbox.LostFocus += new System.Windows.RoutedEventHandler(this.PWTextbox_LostFocus);
            
            #line default
            #line hidden
            return;
            case 4:
            this.LoginBtn = ((System.Windows.Controls.Button)(target));
            
            #line 83 "..\..\..\..\Wins\Auth.xaml"
            this.LoginBtn.Click += new System.Windows.RoutedEventHandler(this.LoginBtn_Click);
            
            #line default
            #line hidden
            return;
            case 5:
            this.RegisterBtn = ((System.Windows.Controls.Button)(target));
            
            #line 98 "..\..\..\..\Wins\Auth.xaml"
            this.RegisterBtn.Click += new System.Windows.RoutedEventHandler(this.RegisterBtn_Click);
            
            #line default
            #line hidden
            return;
            case 6:
            this.ResetPwBtn = ((System.Windows.Controls.Button)(target));
            
            #line 100 "..\..\..\..\Wins\Auth.xaml"
            this.ResetPwBtn.Click += new System.Windows.RoutedEventHandler(this.ResetPwBtn_Click);
            
            #line default
            #line hidden
            return;
            }
            this._contentLoaded = true;
        }
    }
}

