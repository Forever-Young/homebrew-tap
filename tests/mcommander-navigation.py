#!/usr/bin/env python3
"""PTY regression check for the installed mcommander formula.

Uses temporary zsh and XDG configuration. Pass --real-config to additionally
check navigation with your existing zsh startup files (e.g. Oh My Posh).
"""
import os, pty, fcntl, termios, struct, select, time, tempfile, pathlib, signal

def run(right, command=False, real=False):
 with tempfile.TemporaryDirectory(prefix='mcommander-navigation-') as tmp:
  root=pathlib.Path(tmp); parent=root/'parent'; child=parent/'child'; child.mkdir(parents=True)
  rc=root/'zsh'; rc.mkdir(); (rc/'.zshrc').write_text("PROMPT='left> '\nRPROMPT="+repr(right)+"\n")
  result=root/'cwd'; marker=root/'ran'
  pid,fd=pty.fork()
  if pid==0:
   os.environ.update(TERM='xterm',SHELL='/bin/zsh',XDG_CONFIG_HOME=str(root/'config'),XDG_CACHE_HOME=str(root/'cache'),XDG_DATA_HOME=str(root/'data'))
   if not real:os.environ['ZDOTDIR']=str(rc)
   os.execv('/opt/homebrew/bin/mcommander',['mcommander','-P',str(result),str(parent),str(parent)])
  fcntl.ioctl(fd,termios.TIOCSWINSZ,struct.pack('HHHH',30,120,0,0))
  output=bytearray()
  def drain(seconds):
   deadline=time.monotonic()+seconds
   while time.monotonic()<deadline:
    if select.select([fd],[],[],0.1)[0]:
     try:output.extend(os.read(fd,65536))
     except OSError:return
  try:
   drain(8)
   right_prompt_visible = not right or right.encode() in output
   if command:
    os.write(fd,('touch '+str(marker)).encode());drain(1);os.write(fd,b'\r');drain(3)
    # Return from the command's terminal view to panels.
    os.write(fd,b'\x0f');drain(1)
   else:
    os.write(fd,b'\x1bOB');drain(.3);os.write(fd,b'\r');drain(2)
   os.write(fd,b'\x1b[21~');drain(1)
   done,status=os.waitpid(pid,os.WNOHANG)
   if not done:os.kill(pid,signal.SIGTERM);os.waitpid(pid,0)
   actual=result.read_text().strip() if result.exists() else '(no cwd output)'
   ok=(marker.exists() if command else actual==str(child)) and done and status==0 and right_prompt_visible
   print(('real config' if real else 'RPROMPT='+repr(right)), 'command' if command else 'navigate', 'PASS' if ok else 'FAIL', 'cwd='+actual, 'marker='+str(marker.exists()))
   return ok
  finally:
   os.close(fd)
if __name__=='__main__':
 import sys
 cases=[run(''),run('RIGHT_PROMPT'),run('RIGHT_PROMPT',command=True)]
 if '--real-config' in sys.argv: cases.append(run('',real=True))
 sys.exit(0 if all(cases) else 1)
