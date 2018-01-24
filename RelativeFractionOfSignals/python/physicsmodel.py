from HiggsAnalysis.CombinedLimit.PhysicsModel import PhysicsModel
import math

class MuAlpha(PhysicsModel):

	def doParametersOfInterest(self):
		self.modelBuilder.doVar("mu[1.0,0.0,2.0]")
		self.modelBuilder.doVar("alpha[0.0,0.0,1.0]")
		
		self.modelBuilder.factory_('expr::inclusive("@0", mu)')
		self.modelBuilder.factory_(
				'expr::a("@0*cos(@1*{pi}/2)*cos(@1*{pi}/2)", mu, alpha)'
					.format(pi=math.pi)
		)
		self.modelBuilder.factory_(
				'expr::b("@0*sin(@1*{pi}/2)*sin(@1*{pi}/2)", mu, alpha)'
					.format(pi=math.pi)
		)
		
		self.modelBuilder.doSet("POI", "mu,alpha")

	def getYieldScale(self, bin, process):
		if self.DC.isSignal[process]:
			if process == "siga":
				return "a"
			elif process == "sigb":
				return "b"
			else:
				return "inclusive"
		else:
			return 1.0

mu_alpha = MuAlpha()
