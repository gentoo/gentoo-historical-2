# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/evolution/evolution-1.3.1.ebuild,v 1.4 2003/03/21 16:22:46 liquidx Exp $

IUSE="ssl mozilla ldap doc spell pda ipv6 kerberos"

inherit eutils flag-o-matic gnome.org libtool virtualx gnome2

DB3="db-3.1.17"
S="${WORKDIR}/${P}"
DESCRIPTION="A GNOME groupware application, a Microsoft Outlook workalike"
SRC_URI="${SRC_URI} http://www.sleepycat.com/update/snapshot/${DB3}.tar.gz"
HOMEPAGE="http://www.ximian.com"

SLOT="2" # can co-exist with evolution <= 1.2

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc"

RDEPEND=">=gnome-extra/libgtkhtml-3.0.1
	>=gnome-base/ORBit2-2.6.0
    >=gnome-base/libbonoboui-2.0
    >=gnome-base/gnome-vfs-2.0
    >=gnome-base/libgnomeui-2.0
    >=gnome-base/libglade-2.0
    >=gnome-base/libgnome-2.0
    >=gnome-base/bonobo-activation-2.2.1
    >=dev-libs/libxml2-2.5
    >=gnome-base/gconf-2.0
    >=gnome-extra/gal-1.99.2
    >=net-libs/libsoup-1.99.12
    >=gnome-base/libgnomecanvas-2.2.0.2
    >=gnome-base/libgnomeprintui-2.2
    >=gnome-base/libgnomeprint-2.2
	doc?	 ( >=app-text/scrollkeeper-0.3.10-r1 )
	ssl? ( mozilla? ( >=net-www/mozilla-0.9.9 ) : ( >=dev-libs/openssl-0.9.5 ) )
	ldap?    ( >=net-nds/openldap-2.0 )
	pda?     ( >=gnome-extra/gnome-pilot-2.0.1
			>=dev-libs/pilot-link-0.11.7
            >=gnome-extra/gnome-pilot-conduits-2.0.1 )
    kerberos? ( >=app-crypt/krb5-1.2.5 )
	spell?   ( >=app-text/gnome-spell-1.0.1 )"

DEPEND="${RDEPEND}
	>=sys-devel/libtool-1.4.1-r1
	>=dev-util/intltool-0.20
	sys-devel/gettext
	doc? ( dev-util/gtk-doc )"

pkg_setup() {
    ewarn "This is a Preview Release. According to Ximian : "
    echo
    ewarn "These snapshots of Evolution are UNSTABLE. This means"
    ewarn "that it will probably crash very often, and possibly eat"
    ewarn "your mail, calendar, appointments, anything. The purpose"
    ewarn "of this release is to help users to test the new code; use"
    ewarn "at your own risk, but please do report the bugs."
    echo
    ewarn "It is highly recommended that you make a backup of your 1.2"
    ewarn "~/evolution directory before switching to Evolution 1.3 to"
    ewarn "prevent data loss. If you are using POP mail, please consider"
    ewarn "using the \"Leave messages on server\" option to prevent your"
    ewarn "mail from being erased on the server after download."
    echo
    ewarn "Please read this page for more info:"
    ewarn "http://developer.ximian.com/projects/evolution/release_notes/1.3.1.html"
}

src_compile() {

	# *************************************************************
	#
	#   DB3 compile...
	#
	# *************************************************************

	# Rather ugly hack to make sure pthread mutex support are not enabled ...
	cd ${WORKDIR}/${DB3}/dist
	einfo "Compiling DB3..."
	cd ${WORKDIR}/${DB3}/build_unix
	../dist/configure --prefix=${WORKDIR}/db3 || die

	if [ "`egrep "^LIBS=[[:space:]]*-lpthread" Makefile`" ]
	then
		append-flags "-pthread"
	fi

	make || die
	make prefix=${WORKDIR}/db3 install || die

	# *************************************************************
	#
	#   Evolution compile...
	#
	# *************************************************************

	einfo "Compiling Evolution..."
	cd ${S}
  
	local myconf=""
	local MOZILLA="${MOZILLA_FIVE_HOME}"

	if [ -n "`use pda`" ] ; then
		myconf="${myconf} --with-pisock=/usr --enable-pilot-conduits=yes"
	else
		myconf="${myconf} --enable-pilot-conduits=no"
	fi

	if [ -n "`use ldap`" ] ; then
		myconf="${myconf} --with-openldap=yes --with-static-ldap=no"
	else
		myconf="${myconf} --with-openldap=no"
	fi
    
    # Kerberos
	if [ -n "`use kerberos`" ]; then
		myconf="${myconf} --with-krb5=/usr"
    else
    	myconf="${myconf} --without-krb5"
    fi
        

	# Use Mozilla NSS libs if 'mozilla' *and* 'ssl' in USE
	if [ -n "`use ssl`" -a -n "`use mozilla`" ] ; then
		myconf="${myconf} --enable-nss=yes \
			--with-nspr-includes=${MOZILLA}/include/nspr \
			--with-nspr-libs=${MOZILLA} \
			--with-nss-includes=${MOZILLA}/include/nss \
			--with-nss-libs=${MOZILLA}"
	else
		myconf="${myconf} --without-nspr-libs --without-nspr-includes \
			--without-nss-libs --without-nss-includes"
	fi

	# Else use OpenSSL if 'mozilla' not in USE  ...
	if [ -n "`use ssl`" -a -z "`use mozilla`" ] ; then
		myconf="${myconf} --enable-openssl=yes"
	fi

	if [ -n "`use doc`" ] ; then
		myconf="${myconf} --enable-gtk-doc"
	else
		myconf="${myconf} --disable-gtk-doc"
	fi

	if [ -n "`use ipv6`" ] ; then
		myconf="${myconf} --enable-ipv6=yes"
	else
		myconf="${myconf} --enable-ipv6=no"
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
		${myconf} || die

	#needs to be able to connect to X display to build.
	Xemake || Xmake || die
}

src_install() {

	# omf docs missing in evo-1.3.1
	#cd omf-install
	#cp Makefile Makefile.old
	#sed -e "s:scrollkeeper-update.*::g" Makefile.old > Makefile
	#rm Makefile.old
    
    # fix kde shortcut (evo-1.3.1)
    cd ${S}/data
    cp Makefile Makefile.old
	sed -e 's,^install-kde-applnk:,install-kde-applnk:\n\t$(mkinstalldirs) $(DESTDIR)$(kdedesktopdir); \\,' Makefile.old > Makefile
    rm Makefile.old
        
	cd ${S}

	# Install with $DESTDIR, as in some rare cases $D gets hardcoded
	# into the binaries (seems like a ccache problem at present),
	# because everything is recompiled with the "new" PREFIX, if
	# $DESTDIR is _not_ used.
	make DESTDIR=${D} \
		prefix=/usr \
		mandir=/usr/share/man \
		infodir=/usr/share/info \
		datadir=/usr/share \
		sysconfdir=/etc \
		localstatedir=/var/lib \
		KDE_APPLNK_DIR=/usr/share/applnk \
		install || die

	dodoc AUTHORS COPYING* ChangeLog HACKING MAINTAINERS
	dodoc NEWS README
}

# evo-1.3.1 doesn't seem to have any OMFs
SCROLLKEEPER_UPDATE="0"
