# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-www/w3m/w3m-0.2.2.ebuild,v 1.2 2001/12/29 03:15:03 karltk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Text based WWW browser, supports tables and frames"
SRC_URI="http://prdownloads.sourceforge.net/w3m/${P}.tar.gz"
HOMEPAGE="http://w3m.sourceforge.net/"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2-r3
	>=sys-libs/zlib-1.1.3-r2
	gpm? ( >=sys-libs/gpm-1.19.3-r5 )
	ssl? ( >=dev-libs/openssl-0.9.6b )"

src_compile() {
	# It seems to be hard to configure this program in any reasonable
	# way.
	(
		# Which directory do you want to put the binary?
		echo /usr/bin
		# Which directory do you want to put the support binary files?
		echo /usr/lib/w3m
		# Which directory do you want to put the helpfile?
		echo /usr/share/w3m
		# Which language do you prefer?
		#  1 - Japanese (charset ISO-2022-JP, EUC-JP, Shift_JIS)
		#  2 - English (charset US_ASCII, ISO-8859-1, etc.)
		echo 2
		# Do you want to use Lynx-like key binding?
		echo n
		# Do you want to automatically generate domain parts of passwords
		# for anonymous FTP logins?
		echo n
		# Do you want listing of options?
		echo n
		# Do you want NNTP support?
		echo n
		# Do you want ANSI color escape sequences support?
		echo y
		# Let's do some configurations. Choose config option among the list.
		# 
		# 1 - Baby model    (no color, no menu, no mouse, no cookie, no SSL)
		# 2 - Little model  (color, menu, no mouse, no cookie, no SSL)
		# 3 - Mouse model   (color, menu, mouse, no cookie, no SSL)
		# 4 - Cookie model  (color, menu, mouse, cookie, no SSL)
		# 5 - Monster model (with everything; you need openSSL library)
		# 6 - Customize
		# 
		# Which?
		echo 5
		# Do you want SSL verification support?
		# (Your SSL library must be version 0.8 or later)
		use ssl &>/dev/null && echo y || echo n
		# Input your favorite editor program.
		echo /usr/bin/vi
		# Input your favorite mailer program.
		echo /usr/bin/mail
		# Input your favorite external browser program.
		echo /usr/bin/mozilla
		# Input your favorite C-compiler.
		echo gcc
		# Input your favorite C flags.
		printf "%s" "$CFLAGS"
		# Which terminal library do you want to use? (type "none" if you
		# do not need one)
		printf "%s" "-lncurses"
		# Input additional LD flags other than listed above, if any:
		# (default: -lncurses) : 
		echo
	) | ./configure || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc doc/* README*
	doman doc/w3m.1
}
