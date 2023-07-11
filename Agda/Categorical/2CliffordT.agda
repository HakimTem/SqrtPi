{-# OPTIONS --without-K --exact-split --allow-unsolved-metas #-}
-- add --safe when there are no more holes

-- Soundness and Completeness for ≤ 2-qubit Clifford+T relations

open import Categories.Category -- we need it all
open import Categories.Category.Monoidal using (Monoidal)
open import Categories.Category.Monoidal.Symmetric using (Symmetric)
open import Categories.Category.RigCategory

open import Categorical.SqrtRig

-- Everything is over a SqrtRig
module Categorical.2CliffordT {o ℓ e} {C : Category o ℓ e}
  {M⊎ M× : Monoidal C} {S⊎ : Symmetric M⊎}
  {S× : Symmetric M×} {R : RigCategory C S⊎ S×} (SR : SqrtRig R) where

  open import Data.Product using (Σ; _,_)
  open import Level using (Level)

  -- open import Categories.Category.Monoidal.Interchange.Braided (Symmetric.braided S⊎) using (module swapInner)
  open import Categories.Morphism.Reasoning C
  import Categories.Category.Monoidal.Reasoning as MonR
  open import Categories.Functor.Bifunctor.Properties using ([_]-commute)
  
  open import Categorical.Scalars SR
  open import Categorical.Gates SR
  open import Categorical.MatProp SR
  
  open Category C -- all of it
  open HomReasoning
  open SqrtRig SR
  open Kit R
  -- open MonR M× using (_⟩⊗⟨refl)
  -- open MonR M⊎ using () renaming (_⟩⊗⟨refl to _⟩⊕⟨refl)
  open import Categorical.CtrlH using (CZ↝CX; sCZ↝bCX)

  private
    variable
      A B : Obj
      f g : A ⇒ B
      s t : Scalar
      
  ----------------------------------------------------------------
  -- A14
  A14 : T ^ 2 ≈ S
  A14 = P² ω
  
  -- A15
  A15 : (T ∘ H ∘ S ∘ S ∘ H) ^ 2 ≈ ω ● id
  A15 = begin
    (T ∘ H ∘ S ∘ S ∘ H) ^ 2 ≈⟨ base^-cong (refl⟩∘⟨ refl⟩∘⟨ pullˡ S²≡Z) 2 ⟩
    (T ∘ H ∘ Z ∘ H) ^ 2     ≈⟨ base^-cong (refl⟩∘⟨ HZH≡X) 2 ⟩
    (T ∘ X) ^ 2             ≈⟨ sym-assoc ○ (assoc ⟩∘⟨refl)  ⟩
    (P ω ∘ X ∘ P ω) ∘ X    ≈⟨ PXP ω ⟩∘⟨refl ⟩
    (ω ● X) ∘ X             ≈⟨ ●-assocʳ ⟩
    ω ● (X ∘ X)             ≈⟨ ●-congʳ X²≡id ⟩
    ω ● id                  ∎
  
  -- A16
  A16 : Ctrl Z ∘ (T ⊗₁ id) ≈ (T ⊗₁ id) ∘ Ctrl Z
  A16 = begin
    Ctrl Z ∘ (T ⊗₁ id)                 ≈⟨ ⟺ SWAP-CP-SWAP ⟩∘⟨refl ⟩
    (SWAP ∘ Ctrl Z ∘ SWAP) ∘ (T ⊗₁ id) ≈⟨ sym-assoc ⟩∘⟨refl ○ pullʳ (S×.braiding.⇒.commute (T , id)) ⟩
    (SWAP ∘ Ctrl Z) ∘ (id ⊗₁ T) ∘ SWAP ≈⟨ center (CP-P-right (^-comm 4 1)) ⟩
    SWAP ∘ ((id ⊗₁ T) ∘ Ctrl Z) ∘ SWAP ≈⟨ assoc²'' ○ S×.braiding.⇒.commute (id , T) ⟩∘⟨refl ○ assoc ⟩
    (T ⊗₁ id) ∘ SWAP ∘ Ctrl Z ∘ SWAP   ≈⟨ refl⟩∘⟨ SWAP-CP-SWAP ⟩
    (T ⊗₁ id) ∘ Ctrl Z                 ∎   
  
  -- A17

  -- Postulate classical equivalences (can automatically generate
  -- proof from CKS paper but will probably be huge)

  postulate
    P6 : Ctrl X ∘ SWAP ∘ Ctrl X ∘ SWAP ∘ Ctrl X ≈ SWAP

  -- From CtrlH
  -- CZ↝CX :  id ⊗₁ H ∘ Ctrl Z ∘ id ⊗₁ H ≈ Ctrl X
  -- sCZ↝bCX : H ⊗₁ id ∘ Ctrl Z ∘ H ⊗₁ id ≈ SWAP ∘ Ctrl X ∘ SWAP

  A17-help : T ⊗₁ id ∘ SWAP ∘ Ctrl X ∘ SWAP ∘ Ctrl X ≈ SWAP ∘ Ctrl X ∘ SWAP ∘ Ctrl X ∘ id ⊗₁ T
  A17-help = begin
    T ⊗₁ id ∘ SWAP ∘ Ctrl X ∘ SWAP ∘ Ctrl X
      ≈⟨ {!!} ⟩ -- insert id using CX²≡id : CX ^ 2 ≈ id
    T ⊗₁ id ∘ Ctrl X ∘ Ctrl X ∘ SWAP ∘ Ctrl X ∘ SWAP ∘ Ctrl X
      ≈⟨ {!!} ⟩ -- P6
    T ⊗₁ id ∘ Ctrl X ∘ SWAP
      ≈⟨ {!!} ⟩ -- using CZ-CX on first CX
    T ⊗₁ id ∘ id ⊗₁ H ∘ Ctrl Z ∘ id ⊗₁ H ∘ SWAP
      ≈⟨ {!!} ⟩  -- slide parallel
    id ⊗₁ H ∘ T ⊗₁ id ∘ Ctrl Z ∘ id ⊗₁ H ∘ SWAP
      ≈⟨ {!!} ⟩  -- swap T and CZ using A16
    id ⊗₁ H ∘ Ctrl Z ∘ T ⊗₁ id ∘ id ⊗₁ H ∘ SWAP
      ≈⟨ {!!} ⟩  -- slide parallel
    id ⊗₁ H ∘ Ctrl Z ∘ id ⊗₁ H ∘ T ⊗₁ id ∘ SWAP
      ≈⟨ {!!} ⟩ -- use CZ-CX
    Ctrl X ∘ T ⊗₁ id ∘ SWAP
      ≈⟨ {!!} ⟩ -- naturality
    Ctrl X ∘ SWAP ∘ id ⊗₁ T
      ≈⟨ {!!} ⟩ -- P6
    Ctrl X ∘ Ctrl X ∘ SWAP ∘ Ctrl X ∘ SWAP ∘ Ctrl X ∘ id ⊗₁ T
      ≈⟨ {!!} ⟩ -- CX²≡id : CX ^ 2 ≈ id
    SWAP ∘ Ctrl X ∘ SWAP ∘ Ctrl X ∘ id ⊗₁ T ∎

  A17 : (T ∘ H) ⊗₁ id ∘ Ctrl Z ∘ H ⊗₁ H ∘ Ctrl Z ∘ id ⊗₁ H ≈
        H ⊗₁ id ∘ Ctrl Z ∘ H ⊗₁ H ∘ Ctrl Z ∘ id ⊗₁ (H ∘ T)
  A17 = begin
    (T ∘ H) ⊗₁ id ∘ Ctrl Z ∘ H ⊗₁ H ∘ Ctrl Z ∘ id ⊗₁ H
      ≈⟨ {!!} ⟩ -- parallel
    T ⊗₁ id ∘ H ⊗₁ id ∘ Ctrl Z ∘ H ⊗₁ id ∘ id ⊗₁ H ∘ Ctrl Z ∘ id ⊗₁ H
      ≈⟨ {!!} ⟩ -- sCZ-bCX
    T ⊗₁ id ∘ SWAP ∘ Ctrl X ∘ SWAP ∘ id ⊗₁ H ∘ Ctrl Z ∘ id ⊗₁ H
      ≈⟨ {!!} ⟩ -- CZ-CX
    T ⊗₁ id ∘ SWAP ∘ Ctrl X ∘ SWAP ∘ Ctrl X
      ≈⟨ A17-help ⟩ 
    SWAP ∘ Ctrl X ∘ SWAP ∘ Ctrl X ∘ id ⊗₁ T
      ≈⟨ {!!} ⟩  -- CZ-CX
    SWAP ∘ Ctrl X ∘ SWAP ∘ id ⊗₁ H ∘ Ctrl Z ∘ id ⊗₁ H ∘ id ⊗₁ T
      ≈⟨ {!!} ⟩ -- sCZ-bCX
    H ⊗₁ id ∘ Ctrl Z ∘ H ⊗₁ id ∘ id ⊗₁ H ∘ Ctrl Z ∘ id ⊗₁ H ∘ id ⊗₁ T
      ≈⟨ {!!} ⟩ -- parallel
    H ⊗₁ id ∘ Ctrl Z ∘ (H ⊗₁ H) ∘ Ctrl Z ∘ id ⊗₁ (H ∘ T) ∎
  
  -- A18
  -- A19
  -- A20
