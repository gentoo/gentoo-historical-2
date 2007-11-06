# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/firebird/firebird-2.1.0.16780_beta2-r1.ebuild,v 1.1 2007/11/06 04:49:39 wltjr Exp $

inherit flag-o-matic eutils autotools versionator

#MY_P=Firebird-$(replace_version_separator 4 -)
MY_P=Firebird-${PV/_b/-B}

DESCRIPTION="A relational database offering many ANSI SQL-99 features"
HOMEPAGE="http://firebird.sourceforge.net/"
SRC_URI="mirror://sourceforge/firebird/${MY_P}.tar.bz2
	 doc? (	ftp://ftpc.inprise.com/pub/interbase/techpubs/ib_b60_doc.zip )"

LICENSE="Interbase-1.0"
SLOT="0"
KEYWORDS="~amd64 -ia64 ~x86"
IUSE="doc xinetd examples debug"
RESTRICT="userpriv"

RDEPEND="dev-libs/libedit
	dev-libs/icu"
DEPEND="${RDEPEND}
	doc? ( app-arch/unzip )"
RDEPEND="${RDEPEND}
	xinetd? ( virtual/inetd )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup firebird 450
	enewuser firebird 450 /bin/bash /usr/share/firebird firebird
}

src_unpack() {
	if use doc; then
		# Unpack docs
		mkdir "${WORKDIR}/manuals"
		cd "${WORKDIR}/manuals"
		unpack ib_b60_doc.zip
		cd "${WORKDIR}"
	fi

	unpack "${MY_P}.tar.bz2"

	mkdir -p "${WORKDIR}/../etc" \
		"${WORKDIR}/usr" \
		"${WORKDIR}/var/log/firebird" \
		"${WORKDIR}/var/run/firebird"
	cd "${WORKDIR}/usr"; ln -s "${WORKDIR}/${MY_P}/gen/firebird/bin"
	cd "${WORKDIR}/../etc"; ln -s "${WORKDIR}/${MY_P}/gen/firebird" firebird

	cd "${S}"

	epatch "${FILESDIR}/${P}-deps-flags-libs-paths.patch"

	find "${S}" -name \*.sh -print0 | xargs -0 chmod +x
	rm -rf "${S}"/extern/{editline,icu}

	eautoreconf
}

src_compile() {
	filter-flags -fprefetch-loop-arrays
	filter-mfpmath sse

	econf --prefix=/usr/share/firebird --with-editline \
		$(use_enable !xinetd superserver) \
		$(use_enable debug) \
		${myconf} || die "econf failed"
	emake -j1 || die "error during make"
}

src_install() {
	cd "${S}/gen/firebird"

# Seems to be ignored?
#	insinto /usr/share/firebird/bin
#	dobin bin/{changeRunUser,restoreRootRunUser,changeDBAPassword}.sh
	rm bin/*.sh || die "Could not remove *sh files"

	insinto /usr/bin
	dobin bin/*

	insinto /usr/include
	doins include/*

	insinto /usr/lib
	dolib.so lib/*.so*
	dolib.a lib/*.a*

	insinto /usr/share/firebird
	doins *.msg

	insinto /usr/share/firebird/help
	doins help/help.fdb

	insinto /usr/share/firebird/upgrade
	doins "${S}"/src/misc/upgrade/v2/*

	insinto /etc/firebird
	insopts -m0644 -o firebird -g firebird
	doins misc/*
	doins ../install/misc/aliases.conf
	insopts -m0660 -o firebird -g firebird
	doins security2.fdb

	exeinto /usr/share/firebird/UDF
	doexe UDF/*.so

	exeinto /usr/share/firebird/intl
	doexe intl/*.so
#	newexe intl/libfbintl.so fbintl

	insinto /usr/share/firebird/intl
	doins ../install/misc/fbintl.conf

	diropts -m 755 -o firebird -g firebird
	dodir /var/log/firebird
	dodir /var/run/firebird
	keepdir /var/log/firebird
	keepdir /var/run/firebird

	# create links for backwards compatibility
	cd "${D}/usr/lib"
	ln -s libfbclient.so libgds.so
	ln -s libfbclient.so libgds.so.0
	ln -s libfbclient.so libfbclient.so.1

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${S}/gen/install/misc/${PN}.xinetd.2" ${PN} || die "newins xinetd file failed"
	else
		newinitd "${FILESDIR}/${PN}.init.d.2" ${PN}
		newconfd "${FILESDIR}/firebird.conf.d.2" ${PN}
		fperms 640 /etc/conf.d/firebird
	fi
	doenvd "${FILESDIR}/70${PN}"

	# Install docs
	use doc && dodoc "${WORKDIR}"/manuals/*

	if use examples; then
		docinto examples
		dodoc examples/*
	fi
}

pkg_postinst() {
	# Hack to fix ownership/perms
	chown -fR firebird:firebird "${ROOT}/etc/firebird" "${ROOT}/usr/share/firebird"
	chmod 750 "${ROOT}/etc/firebird"

	elog
	elog "Firebird is no longer installed in /opt. Binaries are in"
	elog "/usr/bin. The core, udfs, etc are in /usr/share/firebird. Logs"
	elog "are in /var/log/firebird, and lock files in /var/run/firebird"
	elog "Please report any problems or issues to bugs.gentoo.org."
	elog
}

pkg_config() {
	# if found /etc/security.gdb from previous install, backup, and restore as
	# /etc/security2.fdb
	if [ -f "${ROOT}/etc/firebird/security.gdb" ] ; then
		# if we have scurity2.fdb already, back it 1st
		if [ -f "${ROOT}/etc/firebird/security2.fdb" ] ; then
			cp "${ROOT}/etc/firebird/security2.fdb" "${ROOT}/etc/firebird/security2.fdb.old"
		fi
		gbak -B "${ROOT}/etc/firebird/security.gdb" "${ROOT}/etc/firebird/security.gbk"
		gbak -R "${ROOT}/etc/firebird/security.gbk" "${ROOT}/etc/firebird/security2.fdb"
		mv "${ROOT}/etc/firebird/security.gdb" "${ROOT}/etc/firebird/security.gdb.old"
		rm "${ROOT}/etc/firebird/security.gbk"

		# make sure they are readable only to firebird
		chown firebird:firebird "${ROOT}/etc/firebird/{security.*,security2.*}"
		chmod 660 "${ROOT}/etc/firebird/{security.*,security2.*}"

		einfo
		einfo "Converted old security.gdb to security2.fdb, security.gdb has been "
		einfo "renamed to security.gdb.old. if you had previous security2.fdb, "
		einfo "it's backed to security2.fdb.old (all under ${ROOT}/etc/firebird)."
		einfo
	fi

	# we need to enable local access to the server
	if [ ! -f "${ROOT}/etc/hosts.equiv" ] ; then
		touch "${ROOT}/etc/hosts.equiv"
		chown root:0 "${ROOT}/etc/hosts.equiv"
		chmod u=rw,go=r "${ROOT}/etc/hosts.equiv"
	fi

	# add 'localhost.localdomain' to the hosts.equiv file...
	if [ grep -q 'localhost.localdomain$' "${ROOT}/etc/hosts.equiv" 2>/dev/null ] ; then
		echo "localhost.localdomain" >> "${ROOT}/etc/hosts.equiv"
		einfo "Added localhost.localdomain to ${ROOT}/etc/hosts.equiv"
	fi

	# add 'localhost' to the hosts.equiv file...
	if [ grep -q 'localhost$' "${ROOT}/etc/hosts.equiv" 2>/dev/null ] ; then
		echo "localhost" >> "${ROOT}/etc/hosts.equiv"
		einfo "Added localhost to ${ROOT}/etc/hosts.equiv"
	fi

	HS_NAME=`hostname`
	if [ grep -q ${HS_NAME} "${ROOT}/etc/hosts.equiv" 2>/dev/null ] ; then
		echo "${HS_NAME}" >> "${ROOT}/etc/hosts.equiv"
		einfo "Added ${HS_NAME} to ${ROOT}/etc/hosts.equiv"
	fi

	einfo "If you're using UDFs, please remember to move them"
	einfo "to /usr/share/firebird/UDF"
}
