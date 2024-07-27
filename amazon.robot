*** Settings ***
Library  SeleniumLibrary
Library  OperatingSystem

*** Variables ***
${URL}      https://www.amazon.com.br
${BROWSER}  Firefox

# ALTERE SEU EMAIL E SENHA
${EMAIL}        TestCoffee@dowload.bar
${PASSWORD}     test123
${CPF}     92438979003

# DADOS ENDEREÇO
${NOMECOMPLETO}        Valentina Molina Sobrinho
${TELEFONE}      	6130472444
${CEP}      71920700
${ENDERECO}     Residencial Atlântida I, R. das Aroeiras, Q. 107
${NUMEROCASA}     2


*** Test Cases ***
Acessar Amazon e Pesquisar Produto
    [Documentation]  Abrir o site da Amazon e pesquisar por um produto
    Open Browser  ${URL}  ${BROWSER}
    Maximize Browser Window
    Capture Page Screenshot
    
    Wait Until Element Is Visible  id:twotabsearchtextbox
    Click Element  id:twotabsearchtextbox

    Input Text  id:twotabsearchtextbox  Samsung Galaxy S23
    Capture Page Screenshot
    Click Button  id:nav-search-submit-button
    Capture Page Screenshot

    Set Price Range
    Sleep    2
    Wait Until Element Is Visible  id:a-autoid-1-announce
    Click Button    id:a-autoid-1-announce
    Capture Page Screenshot

    Wait Until Element Is Visible    xpath=//a[contains(@class, "a-button-text") and contains(text(), "Ir para o carrinho")]
    Click Element    xpath=//a[contains(@class, "a-button-text") and contains(text(), "Ir para o carrinho")]
    Capture Page Screenshot

    Sleep    2
    Wait Until Element Is Visible    css=input[value="Proceed to checkout"]    timeout=6s
    Click Element    css=input[value="Proceed to checkout"]

    #infelizmente não da pra fazer cadastro por conta de captcha então é nessesario estar logado

    Wait Until Element Is Visible    id=ap_email
    Input Text    id=ap_email    ${EMAIL}

    Wait Until Element Is Visible    id=continue
    Capture Page Screenshot
    Click Element    id=continue

    Sleep    2
    Wait Until Element Is Visible    id=ap_password    timeout=3s
    Capture Page Screenshot
    Input Text    id=ap_password    ${PASSWORD}

    Sleep    2
    Wait Until Element Is Visible    id=signInSubmit    timeout=3s
    Sleep    2
    Click Element    id=signInSubmit

    #talvez apareça captcha aki
    
    Sleep    2
    Handle Possible Add Address Link
    Sleep    2
    
    
    Sleep    2
    Wait Until Page Contains Element    css:span.a-button-text.a-declarative[data-action="a-dropdown-button"]    timeout=10s
    Sleep    2
    Click Element    css:span.a-button-text.a-declarative[data-action="a-dropdown-button"]    

    Sleep    2
    Capture Page Screenshot
    Click Element    id:address-ui-widgets-countryCode-dropdown-nativeId_31

    Sleep    2
    Wait Until Element Is Visible    id=address-ui-widgets-enterAddressFullName    timeout=10s
    Input Text    id=address-ui-widgets-enterAddressFullName    ${NOMECOMPLETO}

    Sleep    2
    Wait Until Element Is Visible    id=address-ui-widgets-enterAddressPhoneNumber    timeout=10s
    Input Text    id=address-ui-widgets-enterAddressPhoneNumber    ${TELEFONE}

    Sleep    2
    Wait Until Element Is Visible    id=address-ui-widgets-enterAddressPostalCode    timeout=10s
    Input Text    id=address-ui-widgets-enterAddressPostalCode    ${CEP}

    Sleep    2
    Wait Until Element Is Visible    id=address-ui-widgets-streetName    timeout=10s
    Input Text    id=address-ui-widgets-streetName    ${ENDERECO}

    Sleep    2
    Wait Until Element Is Visible    id=address-ui-widgets-buildingNumber    timeout=10s
    Input Text    id=address-ui-widgets-buildingNumber    ${NUMEROCASA}

    Sleep    2
    Capture Page Screenshot
    Click Element    xpath://span[@id='address-ui-widgets-form-submit-button']//input[@type='submit']
    
    Sleep    2
    Handle Possible Tax ID Field

    Sleep    10
    Wait Until Element Is Visible    xpath://div[contains(@class, 'a-fixed-left-grid-col') and contains(@class, 'pmts-pix-text-content')]/span[text()='O código Pix gerado para o pagamento é válido por 30 minutos após a finalização do pedido.']    timeout=30s
    Click Element    xpath://div[contains(@class, 'a-fixed-left-grid-col') and contains(@class, 'pmts-pix-text-content')]/span[text()='O código Pix gerado para o pagamento é válido por 30 minutos após a finalização do pedido.']
    Capture Page Screenshot
    
    
    Sleep    2
    Wait Until Element Is Visible    xpath://span[text()='Usar esta forma de pagamento']    timeout=10s
    Click Element    xpath://input[@class='a-button-input a-button-text' and @name='ppw-widgetEvent:SetPaymentPlanSelectContinueEvent']
    Capture Page Screenshot

    Sleep    4
    Click Element    id=submitOrderButtonId
    

    Sleep    2
    Click Element    xpath://span[@class='break-word' and text()='Revise ou edite seus pedidos recentes']
    Sleep    2
    Capture Page Screenshot

    Sleep    2
    Click Element    xpath://a[@class='a-link-normal' and text()='Exibir recibo']
    Capture Page Screenshot

    Sleep    2

    Go To    ${URL}

    Sleep    2
    Wait Until Page Contains Element    id=nav-hamburger-menu    timeout=3s
    Click Element    id=nav-hamburger-menu
    Capture Page Screenshot

    Sleep    2
    Click Element    xpath://a[contains(@class, 'hmenu-item hmenu-compressed-btn') and contains(div, 'Ver tudo')]

    Sleep    2
    Wait Until Page Contains Element    css=.hmenu-item[data-menu-id="16"]    timeout=3s
    Click Element    css=.hmenu-item[data-menu-id="16"]
    Sleep    2
    Capture Page Screenshot
    
    Sleep    2
    Wait Until Page Contains Element    css=.hmenu-item[href*="node=16243890011"]:nth-child(1)    timeout=3s
    Execute JavaScript    document.querySelectorAll('.hmenu-item[href*="node=16243890011"]')[0].click();
    Sleep    2
    Capture Page Screenshot

    
    


*** Keywords ***
Set Price Range
    ${current_url}=  Get Location
    ${new_url}=  Set Variable  ${current_url}&low-price=3000&high-price=
    Go To  ${new_url}

Handle Possible Add Address Link
    Capture Page Screenshot
    ${is_visible}=  Run Keyword And Return Status  Element Should Be Visible  id=add-new-address-popover-link  timeout=2s
    Run Keyword If  ${is_visible}  Click Element  id=add-new-address-popover-link

Handle Possible Tax ID Field
    Capture Page Screenshot
    ${taxid_visible}=  Run Keyword And Return Status  Element Should Be Visible  id=taxid-field  timeout=4s
    Run Keyword If  ${taxid_visible}  
    ...  Input Text  id=taxid-field  ${CPF}
    ...  Sleep  2
    ...  Click Element  xpath=//input[@aria-labelledby='taxid-continue-enabled-announce' and @type='submit']