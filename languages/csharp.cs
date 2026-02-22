using LanguageExt;
using static LanguageExt.Prelude;
using PETaskForce.Domain.Interfaces;

namespace PETaskForce.Application.UseCases.Questionnaires;

public class ChangePublishStatusHandler
{
    private readonly IQuestionnaireRepository _repository;

    public ChangePublishStatusHandler(IQuestionnaireRepository repository)
    {
        _repository = repository;
    }

    public async Task<Option<Unit>> HandleAsync(Guid id, bool publish, CancellationToken ct = default)
    {
        var questionnaire = await _repository.GetByIdAsync(id, ct);

        if (questionnaire.IsNone)
            return None;

        var q = questionnaire.Match(x => x, () => default!);

        if (publish) q.Publish();
        else q.Unpublish();

        await _repository.UpdateAsync(q, ct);

        return Some(Unit.Default);
    }
}
