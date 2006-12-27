# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/gnokii/gnokii-0.6.14-r1.ebuild,v 1.1 2006/12/27 10:18:25 mrness Exp $

inherit eutils flag-o-matic linux-info

DESCRIPTION="user space driver and tools for use with mobile phones"
HOMEPAGE="http://www.gnokii.org/"
SRC_URI="http://www.gnokii.org/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls bluetooth ical irda sms postgres mysql usb X"

RESTRICT="test" #test fails; maybe it will work in the future, but till then...

RDEPEND="X? ( >=x11-libs/gtk+-2.8.19 )
	bluetooth? ( >=net-wireless/bluez-libs-2.25 )
	sms? ( >=dev-libs/glib-2.10.3
	       postgres? ( >=dev-db/postgresql-8.0.8 )
	       mysql? ( >=virtual/mysql-4.1 )
	     )
	ical? ( >=dev-libs/libical-0.26.6 )
	usb? ( >=dev-libs/libusb-0.1.11 )"
DEPEND="${RDEPEND}
	irda? ( virtual/os-headers )
	nls? ( >=sys-devel/gettext-0.14.5 )
	>=sys-devel/autoconf-2.59-r7
	>=app-text/recode-3.6-r2"

CONFIG_CHECK="UNIX98_PTYS"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Add proper conditional support for ical and usb USE flags
	epatch "${FILESDIR}"/${P}-configure.in.patch

	if use sms ; then
		local MY_SMSD_DB_OBJS="file.lo"
		local MY_SMSD_DB_LIBS="libfile.la"
		if use postgres; then
			MY_SMSD_DB_OBJS="${MY_SMSD_DB_OBJS} pq.lo"
			MY_SMSD_DB_LIBS="${MY_SMSD_DB_LIBS} libpq.la"
		fi
		if use mysql; then
			MY_SMSD_DB_OBJS="${MY_SMSD_DB_OBJS} mysql.lo"
			MY_SMSD_DB_LIBS="${MY_SMSD_DB_LIBS} libmysql.la"
		fi

		sed -i \
			-e "s/^DB_OBJS.*=.*file[.]lo/DB_OBJS = ${MY_SMSD_DB_OBJS}/" \
			-e "s/^DB_LIBS.*=.*libfile[.]la/DB_LIBS = ${MY_SMSD_DB_LIBS}/" \
			-e 's/\(^.*LIBTOOL.*--mode=finish.*$\)/#\1/' \
			smsd/Makefile

		#Change default database module if pq not supported
		if ! use postgres ; then
			local MY_DEFAULT_DB_MODULE="file"
			if use mysql ; then
				MY_DEFAULT_DB_MODULE="mysql"
			fi
			sed -i -e "s/\"pq\"/\"${MY_DEFAULT_DB_MODULE}\"/" smsd/smsd.c
		fi
	fi
}

src_compile() {
	find po/ -name '*.po' -exec recode latin1..u8 {} \;
	append-ldflags $(bindnow-flags) #avoid QA notices

	autoconf && econf \
		$(use_enable nls) \
		$(use_enable usb) \
		$(use_enable ical) \
		$(use_with X x) \
		--disable-debug \
		--disable-xdebug \
		--disable-rlpdebug \
	    --enable-security \
		--disable-unix98test \
		|| die "configure failed"


	emake -j1 || die "make failed"

	if use sms;	then
		cd "${S}/smsd"

		emake || die "smsd make install failed"

		cd "${S}"
	fi
}

src_install() {
	einstall || die "make install failed"

	if use X; then
		insinto /usr/share/pixmaps
		newins Docs/sample/logo/gnokii.xpm xgnokii.xpm
	fi

	insinto /etc
	doins Docs/sample/gnokiirc
	sed -i -e 's:/usr/local:/usr:' "${D}/etc/gnokiirc"

	doman Docs/man/*
	dodir "/usr/share/doc/${PF}"
	cp -r Docs/sample "${D}/usr/share/doc/${PF}/sample"
	cp -r Docs/protocol "${D}/usr/share/doc/${PF}/protocol"
	rm -rf Docs/man Docs/sample Docs/protocol
	dodoc Docs/*

	# only one file needs suid root to make a pseudo device
	fperms 4755 /usr/sbin/mgnokiidev

	if use sms;	then
		cd "${S}/smsd"

		einstall || die "smsd make install failed"

		cd "${S}"
	fi
}

pkg_postinst() {
	einfo "gnokii does not need it's own group anymore."
	einfo "Make sure the user that runs gnokii has read/write access to the device"
	einfo "which your phone is connected to. eg. chown <user> /dev/ttyS0"
	echo
	ewarn "We received at least one report of gnokii with usb connection breaking the phone,"
	ewarn "which was in need to be serviced afterwards. Be careful if you decide to try that..."
}
