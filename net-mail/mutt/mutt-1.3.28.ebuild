# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Server Team <server@gentoo.org>
# Maintainers: Daniel Robbins <drobbins@gentoo.org>, Aron Griffis <agriffis@gentoo.org>
# /space/gentoo/cvsroot/gentoo-x86/net-mail/mutt/mutt-1.3.22.1.ebuild,v 1.1 2001/09/26 12:06:29 agriffis Exp

S=$WORKDIR/$P
DESCRIPTION="a small but very powerful text-based mail client"
SRC_URI="ftp://ftp.mutt.org/pub/mutt/mutt-${PV}i.tar.gz"
HOMEPAGE="http://www.mutt.org"

DEPEND="virtual/glibc 
	nls? ( sys-devel/gettext ) 
	>=sys-libs/ncurses-5.2 
	slang? ( >=sys-libs/slang-1.4.2 ) 
	ssl? ( >=dev-libs/openssl-0.9.6 )"

src_compile() {
	local myconf
	use nls && myconf="--enable-nls" \
		|| myconf="--disable-nls"
	use ssl && myconf="$myconf --with-ssl" \
		|| myconf="$myconf --without-ssl"
	# --without-slang doesn't work;
	# specify --with-curses if you don't want slang
	# (26 Sep 2001 agriffis)
	use slang && myconf="$myconf --with-slang" \
	          || myconf="$myconf --with-curses"
	./configure --host=$CHOST \
		--prefix=/usr --sysconfdir=/etc/mutt \
		--mandir=/usr/share/man --with-docdir=/usr/share/doc/mutt-$PVR \
		--with-regex --enable-pop --enable-imap --enable-nfs-fix \
		--with-homespool=Maildir $myconf
	assert "./configure failed (myconf=$myconf)"
	cp doc/Makefile doc/Makefile.orig
	sed 's/README.UPGRADE//' doc/Makefile.orig > doc/Makefile
	make || die "make failed (myconf=$myconf)"
}

src_install () {
	make DESTDIR=$D install || die
	find $D/usr/share/doc -type f |grep -v html | xargs gzip
	insinto /etc/mutt
	doins $FILESDIR/Muttrc
}
