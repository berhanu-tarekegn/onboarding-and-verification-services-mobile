/// How [FormScreen] loads its [FormSchema] (extensible without bloating one provider).
enum FormDataSource {
  /// Multi-step wizard backed by bundled JSON assets ([formProvider] + path state).
  assetWizard,

  /// Single form: repository → [FormTemplateModel] → mapper → [DynamicForm] + submit API.
  remoteKybDemo,
}
