# from fastapi import FastAPI, HTTPException, Depends, Request
# from fastapi.responses import JSONResponse
# import httpx
# import os
# from dotenv import load_dotenv

# load_dotenv()  # Load environment variables from .env file

# app = FastAPI()

# PAYSTACK_SECRET_KEY = os.getenv("PAYSTACK_SECRET_KEY")
# if not PAYSTACK_SECRET_KEY:
#     raise ValueError("PAYSTACK_SECRET_KEY not found in environment variables.")

# async def verify_paystack_transaction(reference: str):
#     """Verifies a Paystack transaction using the Paystack API."""
#     url = f"https://api.paystack.co/transaction/verify/{reference}"
#     headers = {
#         "Authorization": f"Bearer {PAYSTACK_SECRET_KEY}",
#         "Content-Type": "application/json",
#     }
#     async with httpx.AsyncClient() as client:
#         try:
#             response = await client.get(url, headers=headers)
#             response.raise_for_status()  # Raise HTTPError for bad responses (4xx or 5xx)
#             data = response.json()
#             return data
#         except httpx.HTTPError as e:
#             print(f"Paystack API error: {e}") #Log the error for debugging
#             raise HTTPException(status_code=500, detail="Paystack API error")
#         except Exception as e:
#             print(f"Unexpected Paystack error: {e}")
#             raise HTTPException(status_code=500, detail="Unexpected Paystack error")


# @app.post("/verify-payment")
# async def verify_payment(request: Request, reference: str):
#     """Verifies a payment and processes the order."""
#     try:
#         data = await verify_paystack_transaction(reference)

#         if data["status"] and data["data"]["status"] == "success":
#             # Payment successful. Perform order processing here.
#             # Example: Update database, send confirmation emails, etc.

#             # Important: You'll likely want to extract order details from the request body
#             # and use them to update your database.

#             # Example (assuming you also send the order ID from the client):
#             # order_id = await request.json()  # Get request body as JSON
#             # order_id = order_id.get("order_id")
#             # if order_id:
#             #     update_order_status(order_id, "paid") # example function
#             # else:
#             #     raise HTTPException(status_code=400, detail="Order ID missing")

#             return JSONResponse({"verified": True, "message": "Payment verified and order processed."})
#         else:
#             raise HTTPException(status_code=400, detail="Payment verification failed.")

#     except HTTPException as e:
#         raise e # Re-raise HTTPException from verify_paystack_transaction
#     except Exception as e:
#         print(f"Verification process error: {e}")
#         raise HTTPException(status_code=500, detail="Internal server error.")

# # Example (replace with your actual database logic)
# # def update_order_status(order_id: str, status: str):
# #     # Your database update logic here
# #     print(f"Order {order_id} status updated to {status}")

# # To run the server:
# # uvicorn main:app --reload