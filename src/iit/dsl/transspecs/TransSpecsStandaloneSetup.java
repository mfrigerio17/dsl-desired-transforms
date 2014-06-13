
package iit.dsl.transspecs;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class TransSpecsStandaloneSetup extends TransSpecsStandaloneSetupGenerated{

	public static void doSetup() {
		new TransSpecsStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

