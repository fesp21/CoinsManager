Template.addressItem.rendered = () ->
  # Truncate function
  truncate = (elem, fieldWidth, position) ->
    elem.truncate
      width: fieldWidth
      token: "..."
      side: position
      multiline: false

  # Truncate address
  $addressTitle = $(this.find ".address_title")
  $coinAddress = $addressTitle.find ".coin_address"
  $addressTitle.parents(".address").find(".show_address").
    data "truncated", $coinAddress.text()

  # Truncate balance
  $coinBalance = $(this.find ".coin_balance")
  $coinValue = $coinBalance.find ".coin_value"
  coinBalanceWidth = $coinBalance.width()
  nameWidth = $coinBalance.find(".coin_name").width()
  valueWidth = coinBalanceWidth - nameWidth
  # TODO: Investigate this 10px issue
  truncate $coinValue, valueWidth - 10, "right"


Template.addressItem.events
  # Click on element in functional panel
  "click .func_panel i": (e) ->
    $this = $(e.target)

    # Show/Hide full address
    if $this.hasClass "show_address"
      message = "Read your address below"
      $addressCard = $this.parents ".address"
      $addressTitle =  $addressCard.find ".address_title"
      actualAddress = $addressCard.find(".copy").data "clipboard-text"
      $addressTitle.toggleClass "is_full"
      if $addressTitle.hasClass "is_full"
        $addressCard.find(".coin_address").text actualAddress
        $addressCard.find(".tip").text message
      else
        $addressCard.find(".coin_address").text $this.data "truncated"

    # Remove address
    if $this.hasClass "remove"
      if confirm "Delete this address?"
        actualAddress = $this.parents(".address").find(".copy").
          data "clipboard-text"
        data =
            address: "#{actualAddress}"

        Meteor.call "remove_address", data, (error, id) ->
          if error
            # Display the error
            Errors.throw error.reason

  # Hover on element in functional panel
  "mouseenter .func_panel i": (e) ->
    $this = $(e.target)
    if $this.hasClass "copy"
      message = "Copy address to clipboard"
    else if $this.hasClass "show_address"
      message = "Show/Hide full address"
    else if $this.hasClass "remove"
      message = "Remove this address"
    $this.parents(".address").find(".tip").text message

  # Hover on any address card
  "mouseenter .address": (e) ->
    $this = $(e.target)
    $(".address.is_active").removeClass("is_active").
      find(".tip").text "Clickable action icons below"
    $this.addClass "is_active"