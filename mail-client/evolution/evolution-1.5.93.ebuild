# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/evolution/evolution-1.5.93.ebuild,v 1.1 2004/08/24 15:07:15 tseng Exp $

inherit eutils virtualx gnome2 debug flag-o-matic

# problems with -O3 on gcc-3.3.1
replace-flags -O3 -O2

DESCRIPTION="A GNOME groupware application, a Microsoft Outlook workalike"
HOMEPAGE="http://ximian.com/products/evolution/"

LICENSE="GPL-2"
SLOT="2.0"
KEYWORDS="~x86"
IUSE="ssl mozilla ldap doc spell ipv6 kerberos crypt nntp debug pda"
RESTRICT="nomirror"

# Top stanza are ximian deps
RDEPEND=">=gnome-extra/libgtkhtml-3.1.20
	>=gnome-extra/gal-2.1.14
	>=gnome-extra/evolution-data-server-0.0.98
	>=net-libs/libsoup-2.1.13
	>=dev-libs/glib-2
	>=dev-libs/libxml2-2
	>=gnome-base/gconf-2
	>=gnome-extra/yelp-2.5.1
	>=gnome-base/libglade-2
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libbonoboui-2.4.2
	>=gnome-base/libgnomecanvas-2.0
	>=gnome-base/libgnomeui-2
	>=gnome-base/libgnomeprint-2
	>=gnome-base/libgnomeprintui-2
	>=x11-themes/gnome-icon-theme-1.2
	>=gnome-base/orbit-2.9.8
	pda? ( >=app-pda/gnome-pilot-2.0.10
			>=app-pda/gnome-pilot-conduits-2.0.10 )
	spell? ( >=app-text/gnome-spell-1.0.5 )
	crypt? ( >=app-crypt/gnupg-1.2.2 )
	ssl? ( mozilla? ( net-www/mozilla )
		   !mozilla? ( >=dev-libs/nspr-4.3
						>=dev-libs/nss-3.8 ) )
	ldap? ( >=net-nds/openldap-2.0 )
	kerberos? ( >=app-crypt/mit-krb5-1.2.5 )"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	dev-util/pkgconfig
	>=sys-devel/libtool-1.4.1-r1
	>=dev-util/intltool-0.30
	sys-devel/gettext
	sys-devel/bison
	doc? ( dev-util/gtk-doc
		>=app-text/scrollkeeper-0.3.10-r1 )"

G2CONF="--disable-default-binary \
		$(use_enable ssl nss) \
		$(use_enable ssl smime) \
		$(use_enable ipv6) \
		$(use_enable nntp) \
		$(use_enable pda pilot-conduits)"

USE_DESTDIR="1"
DOCS="AUTHORS COPYING* ChangeLog HACKING MAINTAINERS NEWS README"
ELTCONF="--reverse-deps"


src_compile() {
	elibtoolize

	if [ "${ARCH}" = "hppa" ]; then
		append-flags "-fPIC -ffunction-sections"
		export LDFLAGS="-ffunction-sections -Wl,--stub-group-size=25000"
	fi

	einfo "Compiling Evolution..."
	cd ${S}
	local myconf=""

	use ldap \
		&& myconf="${myconf} --with-openldap=yes --with-static-ldap=no" \
		|| myconf="${myconf} --with-openldap=no"

	use kerberos \
		&& myconf="${myconf} --with-krb5=/usr" \
		|| myconf="${myconf} --without-krb5"

	myconf="${myconf} --with-kde-applnk-path=no"

	# Use Mozilla's NSS/NSPR libs if 'mozilla' *and* 'ssl' in USE
	# Use standalone NSS/NSPR if only 'ssl' in USE
	# Openssl support doesn't work and has been disabled in cvs

	if use ssl ; then
		if  use mozilla ; then
			NSS_LIB=/usr/lib/mozilla
			NSS_INC=/usr/lib/mozilla/include
		else
			NSS_LIB=/usr/lib
			NSS_INC=/usr/include
		fi

		myconf="${myconf} --enable-nss=yes \
			--with-nspr-includes=${NSS_INC}/nspr \
			--with-nspr-libs=${NSS_LIB} \
			--with-nss-includes=${NSS_INC}/nss \
			--with-nss-libs=${NSS_LIB}"
	else
		myconf="${myconf} --without-nspr-libs --without-nspr-includes \
		--without-nss-libs --without-nss-includes"
	fi

	gnome2_src_configure ${G2CONF} ${myconf}

	# Needs to be able to connect to X display to build.
	Xemake || Xmake || die "make failed"
}

_pkg_postinst() {
	gnome2_gconf_install ${GCONFFILEPATH}
	einfo "To change the default browser if you are not using GNOME, do:"
	einfo "gconftool-2 --set /desktop/gnome/url-handlers/http/command -t string 'mozilla %s'"
	einfo "gconftool-2 --set /desktop/gnome/url-handlers/https/command -t string 'mozilla %s'"
	einfo ""
	einfo "Replace 'mozilla %s' with which ever browser you use."
}

