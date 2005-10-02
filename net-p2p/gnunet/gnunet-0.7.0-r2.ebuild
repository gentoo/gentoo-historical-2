# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gnunet/gnunet-0.7.0-r2.ebuild,v 1.2 2005/10/02 04:20:39 weeve Exp $

inherit eutils libtool

S="${WORKDIR}/GNUnet-${PV}"
DESCRIPTION="GNUnet is an anonymous, distributed, reputation based network."
HOMEPAGE="http://www.gnu.org/software/GNUnet/"
SRC_URI="mirror://gnu//${PN}/GNUnet-${PV}.tar.bz2"
RESTRICT="nomirror"

IUSE="ipv6 mysql sqlite guile nls gtk"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=dev-libs/libgcrypt-1.2.0
	>=media-libs/libextractor-0.5.4
	>=dev-libs/gmp-4.0.0
	sys-libs/zlib
	gtk? ( >=x11-libs/gtk+-2.6.10 )
	sys-apps/sed
	ncurses? ( sys-libs/ncurses )
	mysql? ( >=dev-db/mysql-4.0.24 )
	sqlite? ( >=dev-db/sqlite-3.0.8 )
	guile? ( >=dev-util/guile-1.6.0 )
	nls? ( sys-devel/gettext )"


pkg_setup() {
	if ! use mysql && ! use sqlite; then
		einfo
		einfo "You need to specify at least one of 'mysql' or 'sqlite'"
		einfo "USE flag in order to have properly installed gnunet"
		einfo
		die "Invalid USE flag set"
	fi
}

pkg_preinst() {
	enewgroup gnunet || die "Problem adding gnunet group"
	enewuser gnunet -1 -1 /dev/null gnunet || die "Problem adding gnunet user"
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# make mysql default sqstore if we do not compile sql support 
	# (bug #107330)
	! use sqlite && \
		sed -i 's:default "sqstore_sqlite":default "sqstore_mysql":' \
		contrib/config-daemon.in

	# we do not want to built gtk support with USE=-gtk	
	if ! use gtk ; then
		sed -i "s:AC_DEFINE_UNQUOTED..HAVE_GTK.*:true:" configure.ac
		autoconf || die "autoconf failed"
		libtoolize --copy --force
	fi
}

src_compile() {

	local myconf

	if use ipv6; then
		if use amd64; then
			ewarn "ipv6 in GNUnet does not currently work with amd64 and has been disabled"
		else
			myconf="${myconf} --enable-ipv6"
		fi
	fi

	use mysql || myconf="${myconf} --without-mysql"

	econf \
		$(use_with sqlite) \
		$(use_enable nls) \
		$(use_enable ncurses) \
		$(use_enable guile) \
		${myconf} || die "econf failed"

	emake -j1 || die "emake failed"
}

src_install() {
	make install DESTDIR=${D} || die "make install failed"
	dodoc ABOUT-NLS AUTHORS ChangeLog COPYING INSTALL NEWS PLATFORMS README	README.fr UPDATING
	insinto /etc
	newins contrib/gnunet.root gnunet.conf
	docinto contrib
	dodoc contrib/*
	exeinto /etc/init.d
	newexe ${FILESDIR}/gnunet-0.7.0 gnunet
	dodir /var/lib/GNUnet
	chown gnunet:gnunet ${D}/var/lib/GNUnet
}

pkg_postinst() {
	# make sure permissions are ok
	chown -R gnunet:gnunet /var/lib/GNUnet

	use ipv6 && ewarn "ipv6 support is -very- experimental and prone to bugs"
	einfo
	einfo "To configure"
	einfo "  1) Add user(s) to the gnunet group"
	einfo "  2) Run 'gnunet-setup' to generate your client config file"
	einfo "  3) Run gnunet-setup -d to generate a server config file"
	einfo "  4) Optionally copy the .gnunet/gnunetd.conf into /etc and use as a global server config file"
	einfo
}

