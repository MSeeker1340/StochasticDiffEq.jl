mutable struct ImplicitEMCache{uType,rateType,J,JC,UF,uEltypeNoUnits,noiseRateType,F,dWType} <: StochasticDiffEqMutableCache
  u::uType
  uprev::uType
  du1::rateType
  fsalfirst::rateType
  k::rateType
  z::uType
  dz::uType
  tmp::uType
  gtmp::noiseRateType
  gtmp2::rateType
  J::J
  W::J
  jac_config::JC
  linsolve::F
  uf::UF
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  dW_cache::dWType
end

u_cache(c::ImplicitEMCache)    = (c.uprev2,c.z,c.dz)
du_cache(c::ImplicitEMCache)   = (c.k,c.fsalfirst)

function alg_cache(alg::ImplicitEM,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,
                   uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{true}})
  du1 = zero(rate_prototype)
  J = zeros(uEltypeNoUnits,length(u),length(u)) # uEltype?
  W = zero(J)
  z = zero(u)
  dz = zero(u); tmp = zero(u); gtmp = zero(noise_rate_prototype)
  fsalfirst = zero(rate_prototype)
  k = zero(rate_prototype)

  uf = DiffEqDiffTools.UJacobianWrapper(f,t,p)
  linsolve = alg.linsolve(Val{:init},uf,u)
  jac_config = build_jac_config(alg,f,uf,du1,uprev,u,tmp,dz)
  ηold = one(uEltypeNoUnits)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    reltol = 1e-1 # TODO: generalize
    tol = min(0.03,first(reltol)^(0.5))
  end

  if is_diagonal_noise(prob)
    gtmp2 = gtmp
    dW_cache = nothing
  else
    gtmp2 = zero(rate_prototype)
    dW_cache = zero(ΔW)
  end

  ImplicitEMCache(u,uprev,du1,fsalfirst,k,z,dz,tmp,gtmp,gtmp2,J,W,jac_config,linsolve,uf,
                  ηold,κ,tol,10000,dW_cache)
end

mutable struct ImplicitEMConstantCache{F,uEltypeNoUnits} <: StochasticDiffEqConstantCache
  uf::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
end

function alg_cache(alg::ImplicitEM,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,
                   uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{false}})
  uf = DiffEqDiffTools.UDerivativeWrapper(f,t,p)
  ηold = one(uEltypeNoUnits)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    reltol = 1e-1 # TODO: generalize
    tol = min(0.03,first(reltol)^(0.5))
  end

  ImplicitEMConstantCache(uf,ηold,κ,tol,100000)
end

mutable struct ImplicitEulerHeunCache{uType,rateType,J,JC,UF,uEltypeNoUnits,noiseRateType,F,dWType} <: StochasticDiffEqMutableCache
  u::uType
  uprev::uType
  du1::rateType
  fsalfirst::rateType
  k::rateType
  z::uType
  dz::uType
  tmp::uType
  gtmp::noiseRateType
  gtmp2::rateType
  gtmp3::noiseRateType
  J::J
  W::J
  jac_config::JC
  linsolve::F
  uf::UF
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  dW_cache::dWType
end

u_cache(c::ImplicitEulerHeunCache)    = (c.uprev2,c.z,c.dz)
du_cache(c::ImplicitEulerHeunCache)   = (c.k,c.fsalfirst)

function alg_cache(alg::ImplicitEulerHeun,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,
                   uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{true}})
  du1 = zero(rate_prototype)
  J = zeros(uEltypeNoUnits,length(u),length(u)) # uEltype?
  W = zero(J)
  z = zero(u)
  dz = zero(u); tmp = zero(u); gtmp = zero(noise_rate_prototype)
  fsalfirst = zero(rate_prototype)
  k = zero(rate_prototype)

  uf = DiffEqDiffTools.UJacobianWrapper(f,t,p)
  linsolve = alg.linsolve(Val{:init},uf,u)
  jac_config = build_jac_config(alg,f,uf,du1,uprev,u,tmp,dz)
  ηold = one(uEltypeNoUnits)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    reltol = 1e-1 # TODO: generalize
    tol = min(0.03,first(reltol)^(0.5))
  end

  gtmp2 = zero(rate_prototype)

  if is_diagonal_noise(prob)
      gtmp3 = gtmp2
      dW_cache = nothing
  else
      gtmp3 = zero(noise_rate_prototype)
      dW_cache = zero(ΔW)
  end

  ImplicitEulerHeunCache(u,uprev,du1,fsalfirst,k,z,dz,tmp,gtmp,gtmp2,gtmp3,
                         J,W,jac_config,linsolve,uf,ηold,κ,tol,10000,dW_cache)
end

mutable struct ImplicitEulerHeunConstantCache{F,uEltypeNoUnits} <: StochasticDiffEqConstantCache
  uf::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
end

function alg_cache(alg::ImplicitEulerHeun,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,
                   uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{false}})
  uf = DiffEqDiffTools.UDerivativeWrapper(f,t,p)
  ηold = one(uEltypeNoUnits)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    reltol = 1e-1 # TODO: generalize
    tol = min(0.03,first(reltol)^(0.5))
  end

  ImplicitEulerHeunConstantCache(uf,ηold,κ,tol,100000)
end

mutable struct ImplicitRKMilCache{uType,rateType,J,JC,UF,uEltypeNoUnits,noiseRateType,F} <: StochasticDiffEqMutableCache
  u::uType
  uprev::uType
  du1::rateType
  fsalfirst::rateType
  k::rateType
  z::uType
  dz::uType
  tmp::uType
  gtmp::noiseRateType
  gtmp2::noiseRateType
  gtmp3::noiseRateType
  J::J
  W::J
  jac_config::JC
  linsolve::F
  uf::UF
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
end

u_cache(c::ImplicitRKMilCache)    = (c.uprev2,c.z,c.dz)
du_cache(c::ImplicitRKMilCache)   = (c.k,c.fsalfirst)

function alg_cache(alg::ImplicitRKMil,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,
                   uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{true}})
  du1 = zero(rate_prototype)
  J = zeros(uEltypeNoUnits,length(u),length(u)) # uEltype?
  W = zero(J)
  z = zero(u)
  dz = zero(u); tmp = zero(u); gtmp = zero(noise_rate_prototype)
  fsalfirst = zero(rate_prototype)
  k = zero(rate_prototype)

  uf = DiffEqDiffTools.UJacobianWrapper(f,t,p)
  linsolve = alg.linsolve(Val{:init},uf,u)
  jac_config = build_jac_config(alg,f,uf,du1,uprev,u,tmp,dz)
  ηold = one(uEltypeNoUnits)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    reltol = 1e-1 # TODO: generalize
    tol = min(0.03,first(reltol)^(0.5))
  end

  gtmp2 = zero(rate_prototype)
  gtmp3 = zero(rate_prototype)

  ImplicitRKMilCache(u,uprev,du1,fsalfirst,k,z,dz,tmp,gtmp,gtmp2,gtmp3,
                   J,W,jac_config,linsolve,uf,ηold,κ,tol,10000)
end

mutable struct ImplicitRKMilConstantCache{F,uEltypeNoUnits} <: StochasticDiffEqConstantCache
  uf::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
end

function alg_cache(alg::ImplicitRKMil,prob,u,ΔW,ΔZ,p,rate_prototype,noise_rate_prototype,
                   uEltypeNoUnits,uBottomEltype,tTypeNoUnits,uprev,f,t,::Type{Val{false}})
  uf = DiffEqDiffTools.UDerivativeWrapper(f,t,p)
  ηold = one(uEltypeNoUnits)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    reltol = 1e-1 # TODO: generalize
    tol = min(0.03,first(reltol)^(0.5))
  end

  ImplicitRKMilConstantCache(uf,ηold,κ,tol,100000)
end
