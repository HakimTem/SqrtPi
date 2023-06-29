{-# OPTIONS --without-K --exact-split --allow-unsolved-metas #-}
-- not --safe right now as we have holes

open import Categories.Category -- we need it all
open import Categories.Category.Monoidal using (Monoidal)
open import Categories.Category.Monoidal.Symmetric using (Symmetric)
open import Categories.Category.RigCategory
open import Categorical.SqrtRig using (SqrtRig; module Kit)

-- Everything is over a SqrtRig
module Categorical.Scalars {o ℓ e} {𝒞 : Category o ℓ e} {M⊎ M× : Monoidal 𝒞} {S⊎ : Symmetric M⊎}
  {S× : Symmetric M×} {R : RigCategory 𝒞 S⊎ S×} (SR : SqrtRig R) where

  open import Data.Product using (_,_)
  open import Level using (Level)

  -- open import Categories.Category.Monoidal.Properties using (module Kelly's)
  import Categories.Category.Monoidal.Braided.Properties as BraidProp
  import Categories.Category.Monoidal.Reasoning as MonR
  import Categories.Morphism.Reasoning as MR
  
  private
    module M⊎ = Monoidal M⊎
    module M× = Monoidal M×
    module S⊎ = Symmetric S⊎
    module S× = Symmetric S×
    
  open Category 𝒞 -- all of it
  open HomReasoning
  open MR 𝒞
  open SqrtRig SR
  open Kit R
  open MonR M× using (refl⟩⊗⟨_; _⟩⊗⟨refl; _⟩⊗⟨_)
  open BraidProp S×.braided using (module Shorthands; braiding-coherence-inv; inv-braiding-coherence)

  -- Define some of our constants.
  i -i -𝟙 : Scalar
  i  = ω ^ 2
  -𝟙 = ω ^ 4
  -i = ω ^ 6

  -- coherence of definitions (by associativity of ∘ )
  -- Lemma 4.4 (i)
  -𝟙²≡𝟙 : -𝟙 ^ 2 ≈ 𝟙
  -𝟙²≡𝟙 = begin
    (ω ^ 4) ∘ ω ^ 4                       ≈⟨ pullʳ (pullʳ assoc) ⟩
    ω ^ 8                                 ≈⟨ E1 ⟩
    𝟙                                     ∎

  i²≡-𝟙 : i ^ 2 ≈ -𝟙
  i²≡-𝟙 = assoc
  
  -i≡-𝟙◎i : -i ≈ -𝟙 ∘ i
  -i≡-𝟙◎i = begin
    ω ^ 6             ≈⟨ pushʳ (pushʳ sym-assoc) ⟩
    ω ^ 4 ∘ ω ^ 2 ∎

  -- short-names for important lemmas
  -- 1. the unitors are equal at the unit (follows from Kelly's Coherence thms)
  -- 2. infrastructure for 'commutative cubes'
  
  -- Proposition prop:scalars
  -- (i)
  {- Guess: not needed
  scalar-comm : {s t : Scalar} → s ∘ t ≈ t ∘ s
  scalar-comm {s} {t} = begin
    s ∘ t ≈⟨ {!!} ⟩
    t ∘ s ∎
  -}
  -- (ii)
  {- guess: not needed
  scalar-inverse : {s t : Scalar} → (s ∘ s ≈ t) → inv s ≈ inv t ∘ s
  scalar-inverse {s} {t} p = {!!}
  -}
  -- (iii) (used in C1)
  -- we don't define a right-handed ● so expand out its definition here
  -- depends crucially on braiding behind coherent.
  -- TODO: clean up the proof by using more combinators
  left-right-● : {A B : Obj} {s : Scalar} {f : A ⇒ B} → s ● f ≈ ρ⇒ ∘ f ⊗₁ s ∘ ρ⇐
  left-right-● {s = s} {f} = begin
    λ⇒ ∘ s ⊗₁ f ∘ λ⇐                ≈˘⟨ inv-braiding-coherence ⟩∘⟨ refl⟩∘⟨ ⟺ (switch-tofromˡ σ braiding-coherence-inv) ⟩
    (ρ⇒ ∘ σ⇐) ∘ s ⊗₁ f ∘ (σ⇒ ∘ ρ⇐)  ≈⟨ sym-assoc ○ assoc ⟩∘⟨refl ⟩
    (ρ⇒ ∘ σ⇐ ∘ s ⊗₁ f) ∘ (σ⇒ ∘ ρ⇐) ≈⟨ (refl⟩∘⟨ S×.braiding.⇐.commute (f , s)) ⟩∘⟨refl ⟩
    (ρ⇒ ∘ f ⊗₁ s ∘ σ⇐) ∘ (σ⇒ ∘ ρ⇐)  ≈⟨ sym-assoc ○ assoc²' ⟩∘⟨refl ⟩
    (ρ⇒ ∘ f ⊗₁ s ∘ σ⇐ ∘ σ⇒) ∘ ρ⇐    ≈⟨ (refl⟩∘⟨ elimʳ (S×.braiding.iso.isoˡ _)) ⟩∘⟨refl ⟩
    (ρ⇒ ∘ f ⊗₁ s) ∘ ρ⇐               ≈⟨ assoc ⟩
    ρ⇒ ∘ f ⊗₁ s ∘ ρ⇐                 ∎
    where open Shorthands
  
  -- (iv)
  𝟙●f≈f : {A B : Obj} (f : A ⇒ B ) → 𝟙 ● f ≈ f
  𝟙●f≈f f = begin
    λ⇒ ∘ 𝟙 ⊗₁ f ∘ λ⇐ ≈⟨ pullˡ M×.unitorˡ-commute-from ⟩
    (f ∘ λ⇒) ∘ λ⇐    ≈⟨ cancelʳ M×.unitorˡ.isoʳ ⟩
    f               ∎

  -- (v)
  push-scalar-left : {A B : Obj} {s t : Scalar} {f : A ⇒ B} →
    s ● (t ● f) ≈ (s ∘ t) ● f
  push-scalar-left {s = s} {t} {f} = begin
    λ⇒ ∘ s ⊗₁ (λ⇒ ∘ t ⊗₁ f ∘ λ⇐) ∘ λ⇐                     ≈⟨ {!!} ⟩
    λ⇒ ∘ (s ∘ t) ⊗₁ f ∘ λ⇐                                  ∎
  
  -- (vi)
  ●-distrib-⊕ : {A B C D : Obj} {s : Scalar} {f : A ⇒ B} {g : C ⇒ D} →
    s ● (f ⊕₁ g) ≈ (s ● f) ⊕₁ (s ● g)
  ●-distrib-⊕ {s = s} {f} {g} = begin
    λ⇒ ∘ s ⊗₁ (f ⊕₁ g) ∘ λ⇐                   ≈⟨ {!!} ⟩
    (λ⇒ ∘ s ⊗₁ f ∘ λ⇐) ⊕₁ (λ⇒ ∘ s ⊗₁ g ∘ λ⇐) ∎

  -- (vii)
  ●-assocˡ : {A B C : Obj} {s : Scalar} {f : A ⇒ B} {g : B ⇒ C} →
    s ● (g ∘ f) ≈ (s ● g) ∘ f
  ●-assocˡ {s = s} {f} {g} = begin
     λ⇒ ∘ s ⊗₁ (g ∘ f) ∘ λ⇐           ≈˘⟨ refl⟩∘⟨ identityʳ ⟩⊗⟨refl ⟩∘⟨refl ⟩
     λ⇒ ∘ ((s ∘ id) ⊗₁ (g ∘ f)) ∘ λ⇐  ≈⟨ refl⟩∘⟨ M×.⊗.homomorphism ⟩∘⟨refl ⟩
     λ⇒ ∘ ((s ⊗₁ g) ∘ (id ⊗₁ f)) ∘ λ⇐ ≈⟨ refl⟩∘⟨ pullʳ (⟺ M×.unitorˡ-commute-to) ⟩
     λ⇒ ∘ s ⊗₁ g ∘ λ⇐ ∘ f             ≈⟨ pushʳ sym-assoc ⟩
     (λ⇒ ∘ s ⊗₁ g ∘ λ⇐) ∘ f            ∎

  -- (viii)
  ●-over-∘ : {A B C : Obj} {s : Scalar} {f : A ⇒ B} {g : B ⇒ C} →
     s ● (g ∘ f) ≈ g ∘ (s ● f)
  ●-over-∘ {s = s} {f} {g} = begin
     λ⇒ ∘ s ⊗₁ (g ∘ f) ∘ λ⇐           ≈˘⟨ refl⟩∘⟨ identityˡ ⟩⊗⟨refl ⟩∘⟨refl ⟩
     λ⇒ ∘ ((id ∘ s) ⊗₁ (g ∘ f)) ∘ λ⇐  ≈⟨ refl⟩∘⟨ M×.⊗.homomorphism ⟩∘⟨refl ⟩
     λ⇒ ∘ ((id ⊗₁ g) ∘ (s ⊗₁ f)) ∘ λ⇐ ≈⟨ assoc²'' ⟩
     (λ⇒ ∘ id ⊗₁ g) ∘ s ⊗₁ f ∘ λ⇐     ≈⟨ M×.unitorˡ-commute-from ⟩∘⟨refl ⟩
     (g ∘ λ⇒) ∘ s ⊗₁ f ∘ λ⇐           ≈⟨ assoc ⟩
     g ∘ λ⇒ ∘ s ⊗₁ f ∘ λ⇐   ∎ 

  -----------------------------
  -- extra lemmas that are implicitly assumed currently
  ●-cong : {A B : Obj} {s t : Scalar} {f g : A ⇒ B} → s ≈ t → f ≈ g →
    s ● f ≈ t ● g
  ●-cong s≈t f≈g = refl⟩∘⟨ s≈t ⟩⊗⟨ f≈g ⟩∘⟨refl
  
  ●-congʳ : {A B : Obj} {s : Scalar} {f g : A ⇒ B} → f ≈ g →
    s ● f ≈ s ● g
  ●-congʳ f≈g = ●-cong Equiv.refl f≈g

  ●-congˡ : {A B : Obj} {s t : Scalar} {f : A ⇒ B} → s ≈ t →
    s ● f ≈ t ● f
  ●-congˡ s≈t = ●-cong s≈t Equiv.refl
  
  scalar-●≈∘ : {s t : Scalar} → s ● t ≈ s ∘ t
  scalar-●≈∘ {s = s} {t} = begin
    λ⇒ ∘ (s ⊗₁ t) ∘ λ⇐ ≈⟨ {!!} ⟩
    λ⇒ ∘ (s ⊗₁ id) ∘ (id ⊗₁ t) ∘ λ⇐ ≈⟨ {!refl⟩∘⟨ refl⟩∘⟨ (Equiv.sym M×.unitorˡ-commute-to)!} ⟩
    λ⇒ ∘ (s ⊗₁ id) ∘ λ⇐ ∘ t ≈⟨ {!!} ⟩
    (s ● id) ∘ t ≈⟨ {!!} ⟩
    s ∘ t               ∎
  
