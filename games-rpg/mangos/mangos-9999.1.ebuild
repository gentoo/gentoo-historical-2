# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/mangos/mangos-9999.1.ebuild,v 1.1 2009/02/14 07:51:02 trapni Exp $

# TODO:
# - make use of system's zlib/zthread ebuilds instead of mangos' packaged
# - create ebuilds for specific releases (and related patchsets, if desired)

inherit eutils git subversion autotools

MANGOS_REPO_URI="git://github.com/mangos/mangos.git"
SD2_REPO_URI="https://scriptdev2.svn.sourceforge.net/svnroot/scriptdev2"

EGIT_REPO_URI="${MANGOS_REPO_URI}"
ESVN_REPO_URI="${SD2_REPO_URI}"

DESCRIPTION="Massive Network Game Object Server"
HOMEPAGE="http://getmangos.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli ra sd2 debug mysql postgres"

RDEPEND="postgres? ( virtual/postgresql-server )
		 mysql? ( >=virtual/mysql-4.1 )
		 !mysql? ( !postgres? ( >=virtual/mysql-4.1 ) )"

DEPEND="${RDEPEND}
		>=sys-devel/gcc-3.2
		sys-devel/make
		sys-devel/automake
		sys-devel/autoconf
		dev-libs/glib
		dev-libs/openssl"

## setup some env vars we use everywhere (but might change from ebuild to ebuild)
setup_env() {
#	export PREFIX='/usr'
#	export SYSCONFDIR='/etc/mangos'
#	export LOGDIR='/var/log/mangos'

	export PREFIX='/opt/mangos'
	export SYSCONFDIR='/opt/mangos/etc'
	export LOGDIR='/opt/mangos/log'

	export PV_FILES='9999'
}

pkg_setup() {
	if useq mysql && useq postgres; then
		eerror "Please decide with database you want to use for this ebuild by"
		eerror "explicitely enabling/disabling the mysql and postgres USE-flags!"
		die "Both useflags - mysql and postgres - has been specified. Choose one of them only!"
	fi
	enewgroup mangos
	enewuser mangos
}

## unpacks SD2 (ScriptDev2) into mangos workdir
sd2_src_unpack() {
	S="${S}/src/bindings/ScriptDev2" ESVN_REPO_URI="${SD2_REPO_URI}" subversion_src_unpack || die

	local PATCHES_DIR="${S}/src/bindings/ScriptDev2/patches"
	local FILE=$(ls ${PATCHES_DIR} | sort -f -r | awk "NR == 1")

	EPATCH_OPTS="-d ${S}" EPATCH_FORCE="yes" epatch "${PATCHES_DIR}/${FILE}" || die
}

src_unpack() {
	git_src_unpack

	useq sd2 && sd2_src_unpack

	cd "${S}" || die
	eautoreconf --force --install || die "eautoreconf failed"
}

src_compile() {
	setup_env
	local myconf

	if ! useq mysql && ! useq postgres; then
		# defaulth to mysql in case nothing has been specified.
		myconf="${myconf} --with-mysql"
	fi

	mkdir obj || die
	cd obj

	ECONF_SOURCE=.. econf \
		--with-gnu-ld \
		${myconf} \
		--prefix=${PREFIX} \
		--sysconfdir=${SYSCONFDIR} \
		$(use_with mysql) \
		$(use_with postgres postgresql) \
		$(use_enable cli) \
		$(use_enable ra) \
		$(use_enable doc doxygen) \
		$(use_enable debug debug-info) \
		|| die "econf failed"

	emake || die "emake with current options failed"
}

src_install() {
	setup_env

	cd obj

	emake DESTDIR="${D}" install || die "emake install failed"

	rm -f "${D}${PREFIX}/bin/genrevision" # not really part of mangos dist

	doinitd "${FILESDIR}/${PV_FILES}/mangos-realmd" || die
	doinitd "${FILESDIR}/${PV_FILES}/mangos-worldd" || die

	dodir ${PREFIX}/share/mangos/dbc
	dodir ${PREFIX}/share/mangos/maps
	dodir ${PREFIX}/share/mangos/vmaps

	if useq sd2; then
		local DIRS=(sql sql/Updates sql/Updates/0.0.1 sql/Updates/0.0.2)

		for dir in ${DIRS[*]}; do
			dodir ${PREFIX}/share/sd2/${dir} || die
			cp -r ../src/bindings/ScriptDev2/${dir}/*.sql ${D}${PREFIX}/share/sd2/${dir} || die
		done
	fi

	dodir ${LOGDIR}

	fowners root.mangos /etc/mangos
	fowners mangos.mangos /var/log/mangos
}

pkg_postinst() {
	setup_env

	ewarn "You need to manually configure MaNGOS."
	ewarn "See /etc/mangos/ for config files."
	ewarn "Remember to move you maps, DBC and vmaps files to your data folder - ${PREFIX}/share/mangos/"
	ewarn
	ewarn "Don't forget to run SQL scripts for:"
	ewarn "\t- MaNGOS databases : ${PREFIX}/share/mangos/sql"

	useq sd2 && ewarn "\t- ScriptDev2 database: /usr/share/scriptdev2/sql"

	ewarn
	einfo "If you want Mangos to start automatically on boot execute :"
	einfo "\t- rc-update add mangos-realmd default"
	einfo "\t- rc-update add mangos-worldd default"
	einfo
}
