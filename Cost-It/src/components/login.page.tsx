import { useState, type SetStateAction} from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Eye, EyeOff, Mail, Lock } from "lucide-react";

const LoginPage = () => {
  const [showPassword, setShowPassword] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log("Login attempt:", { email, password });
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-accent/20 to-background flex items-center justify-center p-4">
      <Card className="w-full max-w-md shadow-elegant border-0 backdrop-blur-sm bg-card/95">
        <CardContent className="p-8 space-y-6">
          {/* Header */}
          <div className="text-center space-y-2">
            <h1 className="text-3xl font-bold text-primary">Welcome Back</h1>
            <p className="text-muted-foreground">Sign in to your account</p>
          </div>

          {/* Social Login Buttons */}
          <div className="space-y-3">
            <Button
              variant="outline"
              className="w-full h-11 text-google border-google/20 hover:bg-google/5 hover:border-google/40 transition-smooth"
            >
              <svg className="w-5 h-5 mr-3" viewBox="0 0 24 24">
                <path
                  fill="currentColor"
                  d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                />
                <path
                  fill="currentColor"
                  d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                />
                <path
                  fill="currentColor"
                  d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                />
                <path
                  fill="currentColor"
                  d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                />
              </svg>
              Continue with Google
            </Button>

            <Button
              variant="outline"
              className="w-full h-11 text-facebook border-facebook/20 hover:bg-facebook/5 hover:border-facebook/40 transition-smooth"
            >
              <svg className="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 24 24">
                <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
              </svg>
              Continue with Facebook
            </Button>

            <Button
              variant="outline"
              className="w-full h-11 text-apple border-apple/20 hover:bg-apple/5 hover:border-apple/40 transition-smooth"
            >
              <svg className="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12.017 0C8.396 0 8.086.014 6.878.072 5.67.131 4.865.333 4.169.63c-.722.31-1.334.726-1.944 1.336C1.615 2.576 1.199 3.188.889 3.91c-.297.696-.499 1.501-.558 2.709C.273 7.827.26 8.137.26 11.759c0 3.621.014 3.932.072 5.14.059 1.207.261 2.012.558 2.708.31.722.726 1.334 1.336 1.944.61.61 1.222 1.026 1.944 1.336.696.297 1.501.499 2.709.558 1.208.058 1.518.072 5.14.072 3.621 0 3.932-.014 5.14-.072 1.207-.059 2.012-.261 2.708-.558.722-.31 1.334-.726 1.944-1.336.61-.61 1.026-1.222 1.336-1.944.297-.696.499-1.501.558-2.708.058-1.208.072-1.519.072-5.14 0-3.622-.014-3.932-.072-5.14-.059-1.207-.261-2.012-.558-2.709-.31-.722-.726-1.334-1.336-1.944C19.481 1.615 18.869 1.199 18.147.889c-.696-.297-1.501-.499-2.708-.558C14.231.273 13.921.26 10.299.26l1.718-.001zM5.838 5.11h3.403c.024 1.326.037 1.482.111 2.28.063.677.24 1.04.4 1.284.205.312.451.532.747.661.7.305 1.601.457 3.312.457 1.712 0 2.612-.152 3.312-.457.296-.129.542-.349.747-.661.16-.244.337-.607.4-1.284.074-.798.087-.954.111-2.28h3.403c-.024 1.013-.037 1.075-.086 1.564-.063.631-.24.969-.4 1.196-.205.292-.451.501-.747.619-.296.118-.632.177-1.01.196-.378.02-.497.024-1.564.037H7.402c-1.067-.013-1.186-.017-1.564-.037-.378-.019-.714-.078-1.01-.196-.296-.118-.542-.327-.747-.619-.16-.227-.337-.565-.4-1.196-.049-.489-.062-.551-.086-1.564z" />
              </svg>
              Continue with Apple
            </Button>
          </div>

          {/* Divider */}
          <div className="relative">
            <div className="absolute inset-0 flex items-center">
              <Separator className="w-full" />
            </div>
            <div className="relative flex justify-center text-xs uppercase">
              <span className="bg-card px-2 text-muted-foreground">or</span>
            </div>
          </div>

          {/* Login Form */}
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email">Email address</Label>
              <div className="relative">
                <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                <Input
                  id="email"
                  type="email"
                  placeholder="@gmail.com"
                  value={email}
                  onChange={(e: { target: { value: SetStateAction<string>; }; }) => setEmail(e.target.value)}
                  className="pl-10 h-11 border-border focus:ring-2 focus:ring-primary/20 transition-smooth"
                  required
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="password">Password</Label>
              <div className="relative">
                <Lock className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                <Input
                  id="password"
                  type={showPassword ? "text" : "password"}
                  value={password}
                  onChange={(e: { target: { value: SetStateAction<string>; }; }) => setPassword(e.target.value)}
                  className="pl-10 pr-10 h-11 border-border focus:ring-2 focus:ring-primary/20 transition-smooth"
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-3 text-muted-foreground hover:text-foreground transition-smooth"
                >
                  {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </button>
              </div>
            </div>

            <Button
              type="submit"
              className="w-full h-11 bg-gradient-primary hover:opacity-90 text-primary-foreground font-semibold transition-smooth"
            >
              Log In
            </Button>
          </form>

          {/* Footer Links */}
          <div className="text-center space-y-2">
            <a
              href="#"
              className="text-sm text-primary hover:underline transition-smooth"
            >
              Forgot Password?
            </a>
            <p className="text-sm text-muted-foreground">
              No account?{" "}
              <a href="#" className="text-primary hover:underline transition-smooth">
                Create one
              </a>
            </p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default LoginPage;