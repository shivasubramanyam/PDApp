using PatientDemograhics.DataAccess.Patient;
using System.Web.Http;
using Unity;
using Unity.WebApi;

namespace PatientDemographics.API
{
    public static class UnityConfig
    {
        public static void RegisterComponents()
        {
			var container = new UnityContainer();

            // register all your components with the container here
            // it is NOT necessary to register your controllers

            // e.g. container.RegisterType<ITestService, TestService>();
            container.RegisterType<IPatientDemographics, PatientDemograhics.DataAccess.Patient.PatientDemographics>();
            GlobalConfiguration.Configuration.DependencyResolver = new UnityDependencyResolver(container);
        }
    }
}