# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Mikael Hallendal <hallski@gentoo.org>, Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/evolution/evolution-1.0.3-r6.ebuild,v 1.3 2002/04/29 19:50:29 azarah Exp $

#provide Xmake and Xemake
. /usr/portage/eclass/inherit.eclass
inherit virtualx

DB3=db-3.1.17
S=${WORKDIR}/${P}
DESCRIPTION="A GNOME groupware application, a Microsoft Outlook workalike"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/${PN}/${P}.tar.gz
	ftp://ftp.ximian.com/pub/source/${PN}/${P}.tar.gz
	http://people.codefactory.se/~micke/${PN}/${P}.tar.gz
	http://www.sleepycat.com/update/3.1.17/${DB3}.tar.gz"
HOMEPAGE="http://www.ximian.com"

RDEPEND=">=gnome-extra/bonobo-conf-0.14
	>=gnome-base/bonobo-1.0.18
	>=gnome-extra/gal-0.19
	>=gnome-base/gconf-1.0.7
	>=gnome-extra/gtkhtml-1.0.1
	>=gnome-base/oaf-0.6.7
	>=gnome-base/ORBit-0.5.12
	>=gnome-base/libglade-0.17-r1
	>=media-libs/gdk-pixbuf-0.14.0
	>=dev-libs/libxml-1.8.16
	>=gnome-base/gnome-vfs-1.0.2-r1
	>=gnome-base/gnome-print-0.34
	>=app-text/scrollkeeper-0.2
	dev-util/gob
	ssl?     ( >=net-www/mozilla-0.9.9 )
	ldap?    ( >=net-nds/openldap-2.0 )
	mozilla? ( >=net-www/mozilla-0.9.9 )
	pda?     ( >=gnome-extra/gnome-pilot-0.1.61-r2 )
	spell?   ( >=app-text/gnome-spell-0.4.1-r1 )"

# Added dependency on "dev-util/gob" this should fix a configure bug

DEPEND="${RDEPEND}
	>=sys-devel/libtool-1.4.1-r1
	doc? ( dev-util/gtk-doc )
	nls?  ( >=dev-util/intltool-0.11
	        sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	
	cd ${S}
	# Fix the filter crash.  This is actually a problem in the add and
	# edit code.  Mikael Hallendal originally fixed the bug in the add
	# code.  I added the fixes for the edit code.
	#
	# Martin Schlemmer (02 April 2002)
	patch -p0 < ${FILESDIR}/evolution-1.0.3-filter-crash.patch || die
	# add mandrake patches
	# fix KDE detection
	patch -d ${S} -p1 < ${FILESDIR}/evolution-1.0.2-kde.patch || die
	# call pilot conduit applet (not pilot link applet)
	patch -d ${S} -p1 < ${FILESDIR}/evolution-1.0.2-conduit.patch || die
	# Patch from Preston A. Elder to resolve bug #1355
	# fix a problem with literal strings and sertain IMAP servers
	patch -d ${S} -p1 < ${FILESDIR}/evolution-1.0.2-imapfix.diff || die

	# lobtoolize to fix not all libs installing, and buggy .la files.
	# also add the gnome-pilot.m4 to the macros directory to fix
	# problems with the pilot conduct
	cd ${S}
	if [ ! -f ${S}/macros/gnome-pilot.m4 ]
	then
		cp -f ${FILESDIR}/gnome-pilot.m4 ${S}/macros || die
	fi
	[ -z "`use pda`" ] && libtoolize --copy --force
	aclocal -I macros
	automake --add-missing
	autoconf
}

src_compile() {

	cd ${WORKDIR}/${DB3}/build_unix
	../dist/configure --prefix=${WORKDIR}/db3 || die

	make || die
	make prefix=${WORKDIR}/db3 install || die

	cd ${S}
  
	local myconf=""

	MOZILLA=$MOZILLA_FIVE_HOME

	if [ -n "`use pda`" ] ; then
		myconf="${myconf} --with-pisock=/usr --enable-pilot-conduits=yes"
	else
		myconf="${myconf} --enable-pilot-conduits=no"
	fi

	if [ -n "`use ldap`" ] ; then
		myconf="${myconf} --with-openldap=yes"
	else
		myconf="${myconf} --with-openldap=no"
	fi

	if [ -n "`use mozilla`" ] ; then
		myconf="${myconf} --with-nspr-includes=${MOZILLA}/include/nspr \
			        --with-nspr-libs=${MOZILLA}"
	else
		myconf="${myconf} --without-nspr-libs --without-nspr-includes"
	fi

	if [ -n "`use ssl`" ] ; then
		myconf="${myconf} --with-nss-includes=${MOZILLA}/include/nss   \
				--with-nss-libs=${MOZILLA}"
	else
		myconf="${myconf} --without-nss-libs --without-nss-includes"
	fi

	# SSL needs NSPR libs  ...
	if [ -n "`use ssl`" ] && [ -z "`use mozilla`" ] ; then
		myconf="${myconf} --with-nspr-includes=${MOZILLA}/include/nspr \
				--with-nspr-libs=${MOZILLA}"
	fi

	if [ -n "`use doc`" ] ; then
		myconf="${myconf} --enable-gtk-doc"
	else
		myconf="${myconf} --disable-gtk-doc"
	fi

	if [ -z "`use nls`" ] ; then
		myconf="${myconf} --disable-nls"
	fi

	CFLAGS="${CFLAGS} -I/usr/include/libpisock"
	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--with-db3=${WORKDIR}/db3 \
		--disable-python-bindings \
		${myconf} || die

	#needs to be able to connect to X display to build.
	Xemake || Xmake || die
}

src_install() {
	cd omf-install
	cp Makefile Makefile.old
	sed -e "s:scrollkeeper-update.*::g" Makefile.old > Makefile
	rm Makefile.old
	cd ${S}

	# Don't use DESTDIR it violates sandbox // Hallski
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		datadir=${D}/usr/share \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		KDE_APPLNK_DIR=${D}/usr/share/applnk \
		install || die

	dodoc AUTHORS COPYING* ChangeLog HACKING MAINTAINERS
	dodoc NEWS README
}

pkg_postinst() {
	echo ">>> Updating Scrollkeeper database..."
	scrollkeeper-update >/dev/null 2>&1
}

pkg_postrm() {
	echo ">>> Updating Scrollkeeper database..."
	scrollkeeper-update >/dev/null 2>&1
}

