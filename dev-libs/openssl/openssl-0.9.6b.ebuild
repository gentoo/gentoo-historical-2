# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openssl/openssl-0.9.6b.ebuild,v 1.7 2001/11/10 12:05:20 hallski Exp $


S=${WORKDIR}/${P}
DESCRIPTION="Toolkit for SSL v2/v3 and TLS v1"
SRC_URI="http://www.openssl.org/source/${P}.tar.gz"
HOMEPAGE="http://www.opensl.org/"

RDEPEND="virtual/glibc"

DEPEND="${RDEPEND}
	>=sys-devel/perl-5"

src_unpack() {
	unpack ${A}
	cd ${S}
	try patch -p0 < ${FILESDIR}/${P}-Makefile.org-gentoo.diff
	cp Configure Configure.orig
	sed -e "s/-O3/$CFLAGS/" -e "s/-m486//" 				\
    	    Configure.orig > Configure

	# Makefile borkage. The MANDIR is set to ${OPENSSLDIR}/man 
	# which is lame
	sed -e 's:MANDIR=$(OPENSSLDIR)/man:MANDIR=/usr/share/man:g' 	\
	    Makefile | cat > Makefile
}
src_compile() {
	./config --prefix=/usr						\
		 --openssldir=/usr/ssl					\
		 shared threads || die

	make all || die
}

src_install() {
	dodir /usr/ssl
	make INSTALL_PREFIX=${D} install || die

	dodoc CHANGES* FAQ LICENSE NEWS README
	dodoc doc/*.txt
	docinto html
	dodoc doc/*.gif doc/*.html
	insinto /usr/share/emacs/site-lisp
	doins doc/c-indentation.el
}



