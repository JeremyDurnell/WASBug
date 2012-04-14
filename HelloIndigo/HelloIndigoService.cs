// © 2007 Michele Leroux Bustamante. All rights reserved 
// Book: Learning WCF, O'Reilly
// Book Blog: www.thatindigogirl.com
// Michele's Blog: www.dasblonde.net
// IDesign: www.idesign.net
using System;
using System.ServiceModel;
using System.Diagnostics;
using System.Threading;
using System.Windows.Forms;

namespace HelloIndigo
{

    [ServiceContract(Namespace="http://www.thatindigogirl.com/samples/2006/06")]
    public interface IHelloIndigoService
    {
        [OperationContract]
        string HelloIndigo(string s);
    }


    public class HelloIndigoService : IHelloIndigoService
    {
        #region IHelloIndigoService Members

        public string HelloIndigo(string s)
        {
            return String.Format("Message '{0}' received at {1}", s, DateTime.Now);

        }

        #endregion
    }

}

