# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/cups/cups-1.2.12-r6.ebuild,v 1.4 2008/03/23 11:09:38 dertobi123 Exp $

inherit autotools eutils flag-o-matic multilib pam

MY_P=${P/_}

DESCRIPTION="The Common Unix Printing System"
HOMEPAGE="http://www.cups.org/"
SRC_URI="mirror://sourceforge/cups/${MY_P}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="ldap ssl slp pam php samba nls dbus tiff png ppds jpeg X"

DEP="pam? ( virtual/pam )
	ssl? ( net-libs/gnutls )
	slp? ( >=net-libs/openslp-1.0.4 )
	ldap? ( net-nds/openldap )
	dbus? ( sys-apps/dbus )
	png? ( >=media-libs/libpng-1.2.1 )
	tiff? ( >=media-libs/tiff-3.5.5 )
	jpeg? ( >=media-libs/jpeg-6b )
	php? ( dev-lang/php )
	app-text/libpaper"
DEPEND="${DEP}
	!<net-print/foomatic-filters-ppds-20070501
	!<net-print/hplip-1.7.4a-r1
	nls? ( sys-devel/gettext )"
RDEPEND="${DEP}
	nls? ( virtual/libintl )
	!virtual/lpr
	>=app-text/poppler-0.4.3-r1
	X? ( x11-misc/xdg-utils )"

PDEPEND="
	ppds? ( || (
		(
			net-print/foomatic-filters-ppds
			net-print/foomatic-db-ppds
		)
		net-print/foomatic-filters-ppds
		net-print/foomatic-db-ppds
		net-print/hplip
		media-gfx/gimp-print
		net-print/foo2zjs
		net-print/cups-pdf
	) )
	samba? ( >=net-fs/samba-3.0.8 )
	virtual/ghostscript"
PROVIDE="virtual/lpr"

# upstream includes an interactive test which is a nono for gentoo.
# therefore, since the printing herd has bigger fish to fry, for now,
# we just leave it out, even if FEATURES=test
RESTRICT="test"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use x86 && [ -d "/usr/lib64" ]
	then
		eerror "You are running an x86 system, but /usr/lib64 exists, cups will install all library objects into this directory!"
		eerror "You should remove /usr/lib64, but before you do, you should check for existing objects, and re-compile all affected packages."
		eerror "You can use qfile (emerge portage-utils to install qfile) to get a list of the affected ebuilds:"
		eerror "# qfile -qC /usr/lib64"
		die "lib64 on x86 detected"
	fi

	enewgroup lp
	enewuser lp -1 -1 -1 lp

	enewgroup lpadmin 106
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# CVE-2007-4045 security patch, bug #199195
	epatch "${FILESDIR}"/${PN}-1.2.12-CVE-2007-4045.patch
	# CVE-2007-4351 security patch, bug #196736
	epatch "${FILESDIR}"/${PN}-1.2.12-CVE-2007-4351.patch
	# CVE-2007-5849 security patch, bug #201570
	epatch "${FILESDIR}"/${PN}-1.2.12-CVE-2007-5849.patch
	# CVE-2008-0047 security patch, bug #212364
	epatch "${FILESDIR}"/${PN}-1.2.12-CVE-2008-0047.patch
	# CVE-2008-0882 security patch, bug #211449
	epatch "${FILESDIR}"/${PN}-1.2.12-CVE-2008-0882.patch

	# cups does not use autotools "the usual way" and ship a static config.h.in
	eaclocal
	eautoconf
}

src_compile() {
	export DSOFLAGS="${LDFLAGS}"

	if use ldap; then
		append-flags -DLDAP_DEPRECATED
	fi

	econf \
		--with-cups-user=lp \
		--with-cups-group=lp \
		--with-system-groups=lpadmin \
		--localstatedir=/var \
		--with-docdir=/usr/share/cups/html \
		$(use_enable pam) \
		$(use_enable ssl) \
		--enable-gnutls \
		$(use_enable slp) \
		$(use_enable nls) \
		$(use_enable dbus) \
		$(use_enable png) \
		$(use_enable jpeg) \
		$(use_enable tiff) \
		$(use_with php) \
		$(use_enable ldap) \
		--enable-libpaper \
		--enable-threads \
		--enable-static \
		--disable-pdftops \
		|| die "econf failed"

	# Install in /usr/libexec always, instead of using /usr/lib/cups, as that
	# makes more sense when facing multilib support.
	sed -i -e 's:SERVERBIN.*:SERVERBIN = $(BUILDROOT)/usr/libexec/cups:' Makedefs
	sed -i -e 's:#define CUPS_SERVERBIN.*:#define CUPS_SERVERBIN "/usr/libexec/cups":' config.h
	sed -i -e 's:cups_serverbin=.*:cups_serverbin=/usr/libexec/cups:' cups-config

	emake || die "emake failed"
}

src_install() {
	emake BUILDROOT="${D}" install || die "emake install failed"
	dodoc {CHANGES{,-1.{0,1}},CREDITS,LICENSE,README}.txt

	# clean out cups init scripts
	rm -rf "${D}"/etc/{init.d/cups,rc*,pam.d/cups}
	# install our init scripts
	newinitd "${FILESDIR}"/cupsd.init cupsd
	# install our pam script
	pamd_mimic_system cups auth account

	# correct path
	sed -i -e "s:server = .*:server = /usr/libexec/cups/daemon/cups-lpd:" "${D}"/etc/xinetd.d/cups-lpd
	# it is safer to disable this by default, bug 137130
	grep -w 'disable' "${D}"/etc/xinetd.d/cups-lpd || \
		sed -i -e "s:}:\tdisable = yes\n}:" "${D}"/etc/xinetd.d/cups-lpd

	# install pdftops filter
	exeinto /usr/libexec/cups/filter/
	newexe "${FILESDIR}"/pdftops-1.20.gentoo pdftops

	# only for gs-esp this is correct, see bug 163897
	if has_version app-text/ghostscript-gpl || has_version app-text/ghostscript-gnu; then
		sed -i -e "s:#application/vnd.cups-postscript:application/vnd.cups-postscript:" "${D}"/etc/cups/mime.convs
	fi

	keepdir /usr/share/cups/profiles /usr/libexec/cups/driver /var/log/cups \
		/var/run/cups/certs /var/cache/cups /var/spool/cups/tmp /etc/cups/ssl

	# .desktop handling. X useflag. xdg-open from freedesktop is preferred
	if use X; then
		sed -i -e "s:htmlview:xdg-open:" "${D}"/usr/share/applications/cups.desktop
	else
		rm -r "${D}"/usr/share/applications
	fi

	# Fix a symlink collision, see bug #172341
	dodir /usr/share/ppd
	dosym /usr/share/ppd /usr/share/cups/model/foomatic-ppds
}

pkg_preinst() {
	# cleanups
	[ -n "${PN}" ] && rm -fR "${ROOT}"/usr/share/doc/${PN}-*
}

pkg_postinst() {
	echo
	elog "Remote printing: change "
	elog "Listen localhost:631"
	elog "to"
	elog "Listen *:631"
	elog "in /etc/cups/cupsd.conf"
	echo
	elog "For more information about installing a printer take a look at:"
	elog "http://www.gentoo.org/doc/en/printing-howto.xml."
	echo

	local good_gs=false
	for x in app-text/ghostscript-gpl app-text/ghostscript-gnu app-text/ghostscript-esp; do
		if has_version ${x} && built_with_use ${x} cups; then
			good_gs=true
			break
		fi
	done;
	if ! ${good_gs}; then
		ewarn
		ewarn "You need to emerge ghostscript with the \"cups\" USE flag turned on"
	fi
	if has_version =net-print/cups-1.1*; then
		ewarn
		ewarn "The configuration changed with cups-1.2, you may want to save the old"
		ewarn "one and start from scratch:"
		ewarn "# mv /etc/cups /etc/cups.orig; emerge -va1 cups"
		ewarn
		ewarn "You need to rebuild kdelibs for kdeprinter to work with cups-1.2"
	fi
	if [ -e "${ROOT}"/usr/lib/cups ]; then
		ewarn
		ewarn "/usr/lib/cups exists - You need to remerge every ebuild that"
		ewarn "installed into /usr/lib/cups and /etc/cups, qfile is in portage-utils:"
		ewarn "# FEATURES=-collision-protect emerge -va1 \$(qfile -qC /usr/lib/cups /etc/cups | sed \"s:net-print/cups$::\")"
		ewarn
		ewarn "FEATURES=-collision-protect is needed to overwrite the compatibility"
		ewarn "symlinks installed by this package, it wont be needed on later merges."
		ewarn "You should also run revdep-rebuild"

		# place symlinks to make the update smoothless
		for i in "${ROOT}"/usr/lib/cups/{backend,filter}/*; do
			if [ "${i/\*}" == "${i}" ] && ! [ -e ${i/lib/libexec} ]; then
				ln -s ${i} ${i/lib/libexec}
			fi
		done
	fi
}
