package de.jonasbark.stripepayment

import android.os.Bundle
import com.google.android.material.snackbar.Snackbar
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.stripe.android.ApiResultCallback
import com.stripe.android.PaymentConfiguration
import com.stripe.android.Stripe
import com.stripe.android.model.*
import com.stripe.android.view.CardMultilineWidget
import java.lang.Exception


class StripeDialog : androidx.fragment.app.DialogFragment() {

    companion object {
        fun newInstance(title: String): StripeDialog {
            val frag = StripeDialog()
            val args = Bundle()
            args.putString("title", title)
            frag.arguments = args
            return frag
        }

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.activity_stripe, container)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        // Get field from view
        // Fetch arguments from bundle and set title
        val title = arguments?.getString("title", "Add Source")
        dialog?.setTitle(title)

        view.findViewById<View>(R.id.buttonSave)?.setOnClickListener {
            getToken()
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState)

        setStyle(STYLE_NO_TITLE, R.style.Theme_AppCompat_Light_Dialog)
    }

    var tokenListener: ((String) -> (Unit))? = null

    private fun getToken() {
        val mCardInputWidget =
            view?.findViewById<View>(R.id.card_input_widget) as CardMultilineWidget

        if (mCardInputWidget.validateAllFields()) {

            mCardInputWidget.card?.let { card ->

                view?.findViewById<View>(R.id.progress)?.visibility = View.VISIBLE
                view?.findViewById<View>(R.id.buttonSave)?.visibility = View.GONE

                val paymentMethodParamsCard = card.toPaymentMethodParamsCard()
                val paymentMethodCreateParams = PaymentMethodCreateParams.create(
                    paymentMethodParamsCard,
                    PaymentMethod.BillingDetails.Builder().build()
                )

                val stripe =
                    Stripe(activity!!, PaymentConfiguration.getInstance(activity!!).publishableKey)

                stripe.createPaymentMethod(
                    paymentMethodCreateParams,
                    object : ApiResultCallback<PaymentMethod> {
                        override fun onSuccess(result: PaymentMethod) {
                            view?.findViewById<View>(R.id.progress)?.visibility = View.GONE
                            view?.findViewById<View>(R.id.buttonSave)?.visibility = View.GONE

                            if (result.id != null) {
                                tokenListener?.invoke(result.id!!)
                                dismiss()
                            }
                        }

                        override fun onError(error: Exception) {
                            view?.findViewById<View>(R.id.progress)?.visibility = View.GONE
                            view?.findViewById<View>(R.id.buttonSave)?.visibility = View.VISIBLE
                            view?.let {
                                Snackbar.make(it, error.localizedMessage, Snackbar.LENGTH_LONG)
                                    .show()
                            }
                        }

                    })

            }
        } else {
            view?.let {
                Snackbar.make(it, "The card info you entered is not correct", Snackbar.LENGTH_LONG)
                    .show()
            }
        }

    }
}
