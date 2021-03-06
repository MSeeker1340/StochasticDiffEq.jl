struct EMConstantCache <: StochasticDiffEqConstantCache end
struct EMCache{uType,rateType,rateNoiseType,rateNoiseCollectionType,randType} <: StochasticDiffEqMutableCache
  u::uType
  uprev::uType
  tmp::randType
  rtmp1::rateType
  rtmp2::rateNoiseType
  rtmp3::rateNoiseCollectionType
end

u_cache(c::EMCache) = ()
du_cache(c::EMCache) = (c.rtmp1,c.rtmp2)

alg_cache(alg::EM,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{false}}) = EMConstantCache()

function alg_cache(alg::EM,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{true}})
  tmp = zero(u); rtmp1 = zero(rate_prototype);
  rtmp2 = zero(noise_rate_prototype)
  if is_diagonal_noise(prob)
    rtmp3 = rtmp2
  else
    rtmp3 = zero(rate_prototype)
  end
  EMCache(u,uprev,tmp,rtmp1,rtmp2,rtmp3)
end

struct SplitEMConstantCache <: StochasticDiffEqConstantCache end
struct SplitEMCache{uType,rateType,rateNoiseType,rateNoiseCollectionType,randType} <: StochasticDiffEqMutableCache
  u::uType
  uprev::uType
  tmp::randType
  rtmp1::rateType
  rtmp2::rateNoiseType
  rtmp3::rateNoiseCollectionType
end

u_cache(c::SplitEMCache) = ()
du_cache(c::SplitEMCache) = (c.rtmp1,c.rtmp2)

alg_cache(alg::SplitEM,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{false}}) = SplitEMConstantCache()

function alg_cache(alg::SplitEM,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{true}})
  tmp = zero(u); rtmp1 = zero(rate_prototype);
  rtmp2 = zero(noise_rate_prototype)
  if is_diagonal_noise(prob)
    rtmp3 = rtmp2
  else
    rtmp3 = zero(rate_prototype)
  end
  SplitEMCache(u,uprev,tmp,rtmp1,rtmp2,rtmp3)
end

struct EulerHeunConstantCache <: StochasticDiffEqConstantCache end
struct EulerHeunCache{uType,rateType,rateNoiseType,rateNoiseCollectionType,randType} <: StochasticDiffEqMutableCache
  u::uType
  uprev::uType
  tmp::randType
  ftmp1::rateType
  ftmp2::rateType
  nrtmp::rateNoiseCollectionType
  gtmp1::rateNoiseType
  gtmp2::rateNoiseType
end

u_cache(c::EulerHeunCache) = ()
du_cache(c::EulerHeunCache) = (c.rtmp1,c.rtmp2,c.rtmp3,c.rtmp4)

alg_cache(alg::EulerHeun,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{false}}) = EulerHeunConstantCache()

function alg_cache(alg::EulerHeun,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{true}})
  tmp = zero(u); ftmp1 = zero(rate_prototype); ftmp2 = zero(rate_prototype)
  nrtmp = zero(rate_prototype)
  gtmp1 = zero(noise_rate_prototype); gtmp2 = zero(noise_rate_prototype)
  EulerHeunCache(u,uprev,tmp,ftmp1,ftmp2,nrtmp,gtmp1,gtmp2)
end

struct RandomEMConstantCache <: StochasticDiffEqConstantCache end
struct RandomEMCache{uType,rateType,randType} <: StochasticDiffEqMutableCache
  u::uType
  uprev::uType
  tmp::randType
  rtmp::rateType
end

u_cache(c::RandomEMCache) = ()
du_cache(c::RandomEMCache) = (c.rtmp1,c.rtmp2)

alg_cache(alg::RandomEM,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{false}}) = RandomEMConstantCache()

function alg_cache(alg::RandomEM,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{true}})
  tmp = zero(u); rtmp = zero(rate_prototype)
  RandomEMCache(u,uprev,tmp,rtmp)
end

struct RKMilConstantCache <: StochasticDiffEqConstantCache end
struct RKMilCache{uType,rateType,randType} <: StochasticDiffEqMutableCache
  u::uType
  uprev::uType
  du1::rateType
  du2::rateType
  K::rateType
  tmp::randType
  L::rateType
end

u_cache(c::RKMilCache) = ()
du_cache(c::RKMilCache) = (c.du1,c.du2,c.K,c.L)

alg_cache(alg::RKMil,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{false}}) = RKMilConstantCache()

function alg_cache(alg::RKMil,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{true}})
  du1 = zero(rate_prototype); du2 = zero(rate_prototype)
  K = zero(rate_prototype); tmp = zero(u); L = zero(rate_prototype)
  RKMilCache(u,uprev,du1,du2,K,tmp,L)
end

struct RKMilCommuteConstantCache <: StochasticDiffEqConstantCache end
struct RKMilCommuteCache{uType,rateType,rateNoiseType,WikType} <: StochasticDiffEqMutableCache
  u::uType
  uprev::uType
  du1::rateType
  du2::rateType
  K::rateType
  gtmp::rateNoiseType
  L::rateNoiseType
  I::WikType
  Dg::WikType
  mil_correction::rateType
  Kj::uType
  Dgj::rateNoiseType
  tmp::uType
end

u_cache(c::RKMilCommuteCache) = ()
du_cache(c::RKMilCommuteCache) = (c.du1,c.du2,c.K,c.L)

alg_cache(alg::RKMilCommute,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{false}}) = RKMilCommuteConstantCache()

function alg_cache(alg::RKMilCommute,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{true}})
  du1 = zero(rate_prototype); du2 = zero(rate_prototype)
  K = zero(rate_prototype); gtmp = zero(noise_rate_prototype);
  L = zero(noise_rate_prototype); tmp = zero(rate_prototype)
  I = zero(length(ΔW),length(ΔW));
  Dg = zero(length(ΔW),length(ΔW)); mil_correction = zero(rate_prototype)
  Kj = zero(u); Dgj = zero(noise_rate_prototype)
  RKMilCommuteCache(u,uprev,du1,du2,K,gtmp,L,I,Dg,mil_correction,Kj,Dgj,tmp)
end
