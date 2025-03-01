namespace LivePriceBackend.Constants
{
    public static class ErrorMessages
    {
        # region Common

        public const string UserNotFound = "User not found";
        public const string UserOrEmailNotFound = "User or email not found";
        public const string ParityGroupNotFound = "Parity group not found";

        # endregion
        
        # region AuthController

        public const string InvalidUsernameOrPassword = "Invalid username or password";
        public const string InvalidRefreshToken = "Invalid Refresh Token";
        public const string UsernameAlreadyExists = "Username already exists";

        # endregion

        #region UserController

        public const string EmailAlreadyExists = "Email already exists";

        #endregion
        
        #region CustomerController
        
        public const string CustomerNotFound = "Customer not found";
        public const string CustomerNameAlreadyExists = "Customer name already exists";
        
        # endregion
        
        # region ParitiesController
        
        public const string ParityExists = "Parity already exists";
        public const string ParityOrderIndexExists = "Parity order index already exists";
        public const string ParityNotFound = "Parity not found";
        
        # endregion
        
        # region ParityGroupController
        
        public const string ParityGroupExists = "Parity group already exists";
        
        # endregion
    }
}