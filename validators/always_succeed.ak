use aiken/list
use aiken/transaction.{Mint, ScriptContext, Transaction, placeholder}
use aiken/transaction/credential.{Credential, VerificationKeyCredential}
use placeholder.{mock_policy_id, mock_verfication_key_credential}

validator(owner: Credential) {
  fn always_succeed(_redeemer: Data, context: ScriptContext) -> Bool {
    when owner is {
      VerificationKeyCredential(key) -> {
        let signers = context.transaction.extra_signatories
        list.any(signers, fn(x) { x == key })
      }
      _ -> False
    }
  }
}

test succeed_with_param() {
  let vkey = mock_verfication_key_credential()
  let ctx =
    ScriptContext {
      purpose: Mint(mock_policy_id()),
      transaction: Transaction {
        ..placeholder(),
        extra_signatories: [
          #"e822178d3ceaeef383a84cbd41a702b3837360bf889aaac714e6f380731d20d4",
        ],
      },
    }
  always_succeed(vkey, "", ctx)
}
