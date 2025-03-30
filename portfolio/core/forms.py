from django import forms

class PortfolioImportForm(forms.Form):
    json_data = forms.CharField(
        widget=forms.Textarea(attrs={'rows': 20, 'cols': 120})
    )
