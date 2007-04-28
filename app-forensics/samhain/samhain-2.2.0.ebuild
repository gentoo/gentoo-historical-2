# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/samhain/samhain-2.2.0.ebuild,v 1.5 2007/04/28 12:58:58 tove Exp $

KEYWORDS="~x86"
DESCRIPTION="Advanced file integrity and intrusion detection tool."
HOMEPAGE="http://la-samhna.de/samhain/"
SRC_URI="http://la-samhna.de/archive/samhain_signed-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="crypt debug login-watch mounts-check mysql netclient netserver postgres prelude static suidcheck userfiles xml"

RESTRICT="nostrip"

DEPEND="crypt? ( >=app-crypt/gnupg-1.2 )
		mysql? ( virtual/mysql )
		postgres? ( >=dev-db/postgresql-7.2 )
		prelude? ( >=dev-libs/libprelude-0.8.10 )
		>=sys-apps/sed-4
		app-arch/tar
		app-arch/gzip"

# Samhain stealth mode options
#
# If you would like to enable stealth mode, please set and uncomment the 
# following options or pass them as enviroment variables when emerging
# the package (like INSTALL_NAME="asd" emerge samhain).
# If you set the variables here, don't forget to redigest the ebuild by
# issuing 'ebuild samhain-2.1.1a.ebuild digest', also remember that with
# your next emerge sync, the changes to the ebuild will be lost!
#
# Read the Samhain manual for additional information.
#
# STEALTH should be set to either 'full' or 'micro' (mandatory)
#STEALTH=""
#
# XOR_VALUE should be a whole number from 128 to 255 (mandatory)
#XOR_VALUE=""
#
# INSTALL_NAME can be set to change the name of the Samhain binaries
# to the name you specify (optional)
#INSTALL_NAME=""

if [[ "${STEALTH}" == "full" ]] ; then
	RDEPEND="media-gfx/imagemagick"
fi

pkg_setup() {
	if use static ; then
		if use postgres || use prelude ; then
			ewarn "At the moment it isn't possible to build a static Samhain with"
			ewarn "Prelude and/or PostgreSQL support on Gentoo, the compilation"
			ewarn "fails during the linking process."
			echo
			ewarn "This will be looked at and fixed in the future, in the meantime,"
			ewarn "patches to fix this are always welcome and appreciated! ;)"
			ewarn "(Open a bug on bugs.gentoo.org for them or send them to"
			ewarn "the maintainer directly, thanks!)"
			die "Please turn the 'postgres' and/or 'prelude' USE flags off when building with 'static'"
		fi
	fi

	if use mysql && use postgres ; then
		ewarn "You cannot compile both database backends into Samhain at once,"
		ewarn "you need to choose between MySQL or PostgreSQL and disable the"
		ewarn "one you don't want to use."
		die "Please choose between 'mysql' or 'postgres' USE flags"
	fi
}

src_unpack() {
	unpack ${A}
	tar -xzf "samhain-${PV}.tar.gz"
}

src_compile() {
	local myconf

	if use crypt ; then
		myconf="${myconf} --with-gpg=/usr/bin/gpg --with-checksum=no"

		if [[ -n "${KEY_FPR}" ]] ; then
			einfo "Setting built-in key fingerprint to ${KEY_FPR}"
			FPR=`echo ${KEY_FPR} | sed "s/ //g"`
			myconf="${myconf} --with-fp=${FPR}"
		fi
	fi

	if [[ -n "${STEALTH}" ]] ; then
		[[ -z "${XOR_VALUE}" ]] && die "Variable XOR_VALUE must be set for stealth mode"
		echo
		einfo "Enabling stealth mode '${STEALTH}', setting XOR_VALUE to ${XOR_VALUE}"

		if [[ "${STEALTH}" == "full" ]] ; then
			myconf="${myconf} --enable-stealth=${XOR_VALUE}"
			sed -e "s:STEGIN=@stegin_prg@:STEGIN=:g" -i samhain-install.sh.in
		elif [[ "${STEALTH}" == "micro" ]] ; then
			myconf="${myconf} --enable-micro-stealth=${XOR_VALUE}"
		else
			die "STEALTH must be set to either 'full' or 'micro'"
		fi

		if [[ -n "${INSTALL_NAME}" ]] ; then
			echo
			einfo "Setting alternative samhain name to ${INSTALL_NAME}"
			echo
			myconf="${myconf} --enable-install-name=${INSTALL_NAME}"
		fi
	fi

	use mysql && myconf="${myconf} --with-database=mysql --enable-xml-log"
	use postgres && myconf="${myconf} --with-database=postgresql --enable-xml-log"
	use prelude && myconf="${myconf} --with-prelude --with-libprelude-prefix=/usr"
	use xml && myconf="${myconf} --enable-xml-log"
	use static && myconf="${myconf} --enable-static"
	use debug && myconf="${myconf} --enable-debug"

	use netclient && myconf="${myconf} --enable-network=client"
	use netserver && myconf="${myconf} --enable-network=server"

	use login-watch && myconf="${myconf} --enable-login-watch"
	use mounts-check && myconf="${myconf} --enable-mounts-check"
	use suidcheck && myconf="${myconf} --enable-suidcheck"
	use userfiles && myconf="${myconf} --enable-userfiles"

	myconf="${myconf} --localstatedir=/var"

	econf ${myconf} || die "configure failed"
	make || die "compile failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	rm -Rf "${D}/var/log"
	rm -Rf "${D}/var/run"
	rm -Rf "${D}/var/state"

	if [[ -n "${STEALTH}" ]] ; then
		rm -Rf "${D}/usr/share"
	else
		dodoc COPYING LICENSE docs/BUGS docs/MANUAL* docs/README* docs/TODO docs/*.txt
		dohtml docs/*.html
		docinto scripts
		dodoc scripts/*
		insinto /etc
		insopts -m0600
		newins samhainrc.linux samhainrc
		newinitd init/samhain.startGentoo samhain
		keepdir "/var/lib/samhain"
	fi

	if use netserver ; then
		keepdir "/var/lib/yule"
		chown daemon:daemon "${D}/var/lib/yule"
		keepdir "/var/log/yule"
		chown daemon:daemon "${D}/var/log/yule"
	fi
}

pkg_postinst() {
	if [[ -n "${STEALTH}" ]] ; then
		elog
		elog "Manual pages, documentation, and init script were NOT installed in order to"
		elog "obscure Samhain's presence. You should also remove samhain's installation"
		elog "traces from ${ROOT}/var/cache/edb/world and ${ROOT}/var/db/pkg."
	fi

	if [[ "${STEALTH}" == "full" ]] ; then
		elog
		elog "In stealth mode, the configuration file must be steganographically hidden"
		elog "in a postscript image file. The sample config has been created this way by"
		elog "the installation process. Use the samhain_stealth utility to modify or"
		elog "create your own configuration file."
	fi

	if [[ -z "${KEY_FPR}" ]] ; then
		elog
		ewarn "GnuPG support has been enabled, but fingerprint verification will be"
		ewarn "ignored. To enable fingerprint verification (strongly recommended),"
		ewarn "you must re-emerge this package with the KEY_FPR variable set to"
		ewarn "your default signing key fingerprint."
		ewarn "Please read the Samhain manual for more details."
		elog
		elog "Enabling GnuPG support in Samhain requires that you sign your configuration"
		elog "and and database files. Please run the following commands as root:"
		elog
		elog "    gpg -a --clearsign --not-dash-escaped ${ROOT}/etc/samhainrc"
		elog "    mv ${ROOT}/etc/samhainrc.asc ${ROOT}/etc/samhainrc"
		elog "    chmod 600 ${ROOT}/etc/samhainrc"
		elog
		elog "Run the same commands on ${ROOT}/var/lib/samhain/samhain_file after initialization."
	fi

	elog
	elog "Be sure to check your settings in ${ROOT}/etc/samhainrc. When ready, run:"
	elog "    samhain -t init"
	elog "to initialize Samhain."

	elog
	elog "Samhain stealth-mode options are also available. Please view the comments"
	elog "in the Samhain ebuild for further configuration instructions."

	elog
	ewarn "Please be sure to read the Samhain manual to understand and correctly"
	ewarn "configure the Samhain utility."
	ewarn "HTML version available for viewing at http://la-samhna.de/samhain/manual/ ."
}
