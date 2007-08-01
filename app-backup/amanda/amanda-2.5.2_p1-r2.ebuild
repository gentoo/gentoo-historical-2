# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/amanda/amanda-2.5.2_p1-r2.ebuild,v 1.1 2007/08/01 18:42:41 robbat2 Exp $

inherit eutils

DESCRIPTION="The Advanced Maryland Automatic Network Disk Archiver"
HOMEPAGE="http://www.amanda.org/"
SRC_URI="mirror://sourceforge/amanda/${P/_/}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
RDEPEND="sys-libs/readline
		virtual/inetd
		sys-apps/gawk
		app-arch/tar
		dev-lang/perl
		app-arch/dump
		net-misc/openssh
		samba? ( net-fs/samba )
		berkdb? ( sys-libs/db )
		kerberos? ( app-crypt/mit-krb5 )
		gdbm? ( sys-libs/gdbm )
		!sparc? ( xfs? ( sys-fs/xfsdump ) )
		!minimal? ( virtual/mailx
			app-arch/mt-st
			sys-block/mtx
			sci-visualization/gnuplot
			app-crypt/aespipe
			app-crypt/gnupg )"

DEPEND="${RDEPEND}
	sys-devel/autoconf
	sys-devel/automake"

IUSE="berkdb debug gdbm minimal samba xfs kerberos"

S="${WORKDIR}/${P/_/}"
MYFILESDIR="${WORKDIR}/files"
MYTMPDIR="${WORKDIR}/tmp"
MYINSTTMPDIR="/usr/share/amanda"
ENVDIR="/etc/env.d"
ENVDFILE="97amanda"
TMPENVFILE="${MYTMPDIR}/${ENVDFILE}"
TMPINSTENVFILE="${MYINSTTMPDIR}/tmpenv-${ENVDFILE}"

# This is a complete list of Amanda settings that the ebuild takes from the
# build environment. This allows users to alter the behavior of the package as
# upstream intended, but keeping with Gentoo style. We store a copy of them in
# /etc/env.d/97amanda during the install, so that they are preserved for future
# installed.
AMANDA_ENV_SETTINGS="
AMANDA_GROUP_GID AMANDA_GROUP_NAME
AMANDA_USER_NAME AMANDA_USER_UID AMANDA_USER_SH AMANDA_USER_HOMEDIR AMANDA_USER_GROUPS 
AMANDA_SERVER AMANDA_SERVER_TAPE AMANDA_SERVER_INDEX 
AMANDA_TAR_LISTDIR AMANDA_TAR 
AMANDA_PORTS_UDP AMANDA_PORTS_TCP AMANDA_PORTS_BOTH AMANDA_PORTS
AMANDA_CONFIG_NAME AMANDA_TMPDIR AMANDA_DBMODE"

amanda_variable_setup() {

	# Setting vars
	local currentamanda

	# Grab the current settings
	currentamanda="$(set | egrep "^AMANDA_" | xargs)"
	use debug && einfo "Current settings: ${currentamanda}"
	#for i in ${currentamanda}; do
	#	eval `eval echo ${i}`
	#	echo "Setting: ${i}"
	#done;

	# First we set the defaults
	[ -z "${AMANDA_GROUP_GID}" ] && AMANDA_GROUP_GID=87
	[ -z "${AMANDA_GROUP_NAME}" ] && AMANDA_GROUP_NAME=amanda
	[ -z "${AMANDA_USER_NAME}" ] && AMANDA_USER_NAME=amanda
	[ -z "${AMANDA_USER_UID}" ] && AMANDA_USER_UID=87
	[ -z "${AMANDA_USER_SH}" ] && AMANDA_USER_SH=-1
	[ -z "${AMANDA_USER_HOMEDIR}" ] && AMANDA_USER_HOMEDIR=/var/spool/amanda
	[ -z "${AMANDA_USER_GROUPS}" ] && AMANDA_USER_GROUPS="${AMANDA_GROUP_NAME}"

	# This installs Amanda, with the server. However, it could be a client,
	# just specify an alternate server name in AMANDA_SERVER.
	[ -z "${AMANDA_SERVER}" ] && AMANDA_SERVER="${HOSTNAME}"
	[ -z "${AMANDA_SERVER_TAPE}" ] && AMANDA_SERVER_TAPE="${AMANDA_SERVER}"
	[ -z "${AMANDA_SERVER_INDEX}" ] && AMANDA_SERVER_INDEX="${AMANDA_SERVER}"
	[ -z "${AMANDA_TAR_LISTDIR}" ] && AMANDA_TAR_LISTDIR=${AMANDA_USER_HOMEDIR}/tar-lists
	[ -z "${AMANDA_CONFIG_NAME}" ] && AMANDA_CONFIG_NAME=DailySet1
	[ -z "${AMANDA_TMPDIR}" ] && AMANDA_TMPDIR=/var/tmp/amanda
	[ -z "${AMANDA_DBGDIR}" ] && AMANDA_DBGDIR="$AMANDA_TMPDIR"
	# These are left empty by default
	[ -z "${AMANDA_PORTS_UDP}" ] && AMANDA_PORTS_UDP=
	[ -z "${AMANDA_PORTS_TCP}" ] && AMANDA_PORTS_TCP=
	[ -z "${AMANDA_PORTS_BOTH}" ] && AMANDA_PORTS_BOTH=
	[ -z "${AMANDA_PORTS}" ] && AMANDA_PORTS=

	# This one is a little more complicated
	# The priority list is this:
	# 1. 'Berkely DB style' (only if USE="berkdb")
	# 2. 'GDBM style' (only if USE="gdbm")
	# 3. 'Text style'
	[ -z "${AMANDA_DBMODE}" ] && use berkdb && AMANDA_DBMODE=db
	[ -z "${AMANDA_DBMODE}" ] && use gdbm && AMANDA_DBMODE=gdbm
	[ -z "${AMANDA_DBMODE}" ] && AMANDA_DBMODE=text

	# What tar to use
	[ -z "${AMANDA_TAR}" ] && AMANDA_TAR=/bin/tar

	# Now pull in the old stuff
	if [ -f "${ENVDIR}/${ENVDFILE}" ]; then
		# We don't just source it as we don't want everything in there.
		eval $(egrep "^AMANDA_" ${ENVDIR}/${ENVDFILE})
	fi

	# Re-apply the new settings if any
	[ -n "${currentamanda}" ] && eval `echo "${currentamanda}"`

}

pkg_setup() {
	# Now add users if needed
	amanda_variable_setup
	enewgroup "${AMANDA_GROUP_NAME}" "${AMANDA_GROUP_GID}"
	enewuser "${AMANDA_USER_NAME}" "${AMANDA_USER_UID}" "${AMANDA_USER_SH}" "${AMANDA_USER_HOMEDIR}" "${AMANDA_USER_GROUPS}"
}

src_unpack() {
	unpack "${A}"

	# now the real fun
	amanda_variable_setup
	# places for us to work in
	mkdir -p "${MYFILESDIR}" "${MYTMPDIR}"
	# Now we store the settings we just created
	set | egrep "^AMANDA_" > "${TMPENVFILE}"
}

src_compile() {
	# fix bug #36316
	addpredict /var/cache/samba/gencache.tdb

	[ ! -f "${TMPENVFILE}" ] && die "Variable setting file (${TMPENVFILE}) should exist!"
	source "${TMPENVFILE}"
	local myconf
	cd ${S}

	einfo "Using '${AMANDA_DBMODE}' style database"
	myconf="${myconf} --with-db=${AMANDA_DBMODE}"
	einfo "Using ${AMANDA_SERVER_TAPE} for tape server."
	myconf="${myconf} --with-tape-server=${AMANDA_SERVER_TAPE}"
	einfo "Using ${AMANDA_SERVER_INDEX} for index server."
	myconf="${myconf} --with-index-server=${AMANDA_SERVER_INDEX}"
	einfo "Using ${AMANDA_USER_NAME} for amanda user."
	myconf="${myconf} --with-user=${AMANDA_USER_NAME}"
	einfo "Using ${AMANDA_GROUP_NAME} for amanda group."
	myconf="${myconf} --with-group=${AMANDA_GROUP_NAME}"
	einfo "Using ${AMANDA_TAR} as Tar implementation."
	myconf="${myconf} --with-gnutar=${AMANDA_TAR}"
	einfo "Using ${AMANDA_TAR_LISTDIR} as tar listdir."
	myconf="${myconf} --with-gnutar-listdir=${AMANDA_TAR_LISTDIR}"
	einfo "Using ${AMANDA_CONFIG_NAME} as default config name."
	myconf="${myconf} --with-config=${AMANDA_CONFIG_NAME}"
	einfo "Using ${AMANDA_TMPDIR} as Amanda temporary directory."
	myconf="${myconf} --with-tmpdir=${AMANDA_TMPDIR}"

	if [ -n "${AMANDA_PORTS_UDP}" ] && [ -n "${AMANDA_PORTS_TCP}" ] && [ -z "${AMANDA_PORTS_BOTH}" ] ; then
		eerror "If you want _both_ UDP and TCP ports, please use only the"
		eerror "AMANDA_PORTS environment variable for identical ports, or set"
		eerror "AMANDA_PORTS_BOTH."
		die "Bad port setup!"
	fi
	if [ -n "${AMANDA_PORTS_UDP}" ]; then
		einfo "Using UDP ports ${AMANDA_PORTS_UDP/,/-}"
		myconf="${myconf} --with-udpportrange=${AMANDA_PORTS_UDP}"
	fi
	if [ -n "${AMANDA_PORTS_TCP}" ]; then
		einfo "Using TCP ports ${AMANDA_PORTS_TCP/,/-}"
		myconf="${myconf} --with-tcpportrange=${AMANDA_PORTS_TCP}"
	fi
	if [ -n "${AMANDA_PORTS}" ]; then
		einfo "Using ports ${AMANDA_PORTS/,/-}"
		myconf="${myconf} --with-portrange=${AMANDA_PORTS}"
	fi

	# Extras
	# Speed option
	myconf="${myconf} --with-buffered-dump"
	# "debugging" in the configuration is NOT debug in the conventional sense.
	# It is actually just useful output in the application, and should remain
	# enabled. There are some cases of breakage with MTX tape changers as of
	# 2.5.1p2 that it exposes when turned off as well.
	myconf="${myconf} --with-debugging"
	# Where to put our files
	myconf="${myconf} --localstatedir=${AMANDA_USER_HOMEDIR}"

	# Samba support
	myconf="${myconf} `use_with samba smbclient /usr/bin/smbclient`"

	# Support for BSD, SSH, BSDUDP, BSDTCP security methods all compiled in by
	# default
	myconf="${myconf} --with-bsd-security"
	myconf="${myconf} --with-ssh-security"
	myconf="${myconf} --with-bsdudp-security"
	myconf="${myconf} --with-bsdtcp-security"

	# kerberos-security mechanism version 4
	# always disable, per bug #173354
	myconf="${myconf} --without-krb4-security"

	# kerberos-security mechanism version 5
	myconf="${myconf} `use_with kerberos krb5-security`"

	# Client only, as requested in bug #127725
	use minimal && myconf="${myconf} --without-server"

	econf ${myconf} || die "econf failed!"
	emake -j1 || die "emake failed!"

	# Compile the tapetype program too
	# This is deprecated, use amtapetype instead!
	# cd tape-src
	# emake tapetype || die "emake tapetype failed!"

	# Only needed if you we do versioning
	#dosed "s,/usr/local/bin/perl,/usr/bin/perl," ${S}/contrib/set_prod_link.pl
	#perl ${S}/contrib/set_prod_link.pl

}

src_install() {
	[ ! -f "${TMPENVFILE}" ] && die "Variable setting file (${TMPENVFILE}) should exist!"
	source ${TMPENVFILE}

	einfo "Doing stock install"
	make DESTDIR=${D} install || die

	# Prepare our custom files
	einfo "Building custom configuration files"
	cp ${FILESDIR}/amanda-* ${MYFILESDIR}
	local i # our iterator
	local sedexpr # var for sed expr
	sedexpr=''
	for i in ${AMANDA_ENV_SETTINGS} ; do
		local val
		eval "val=\"\${${i}}\""
		sedexpr="${sedexpr}s|__${i}__|${val}|g;"
	done
	#einfo "Compiled SED expression: '${sedexpr}'"

	# now apply the sed expr
	for i in "${FILESDIR}"/amanda-* ; do
		local filename
		filename=`basename ${i}`
		#einfo "Applying compiled SED expression to ${filename}"
		sed -re "${sedexpr}" <${i} >"${MYFILESDIR}/${filename}"
	done

	# Build the envdir file
	# Don't forget this..
	einfo "Building environment file"
	echo "# These settings are what was present in the environment when this" >>${MYFILESDIR}/${ENVDFILE}
	echo "# Amanda was compiled.  Changing anything below this comment will" >>${MYFILESDIR}/${ENVDFILE}
	echo "# have no effect on your application, but it merely exists to" >>${MYFILESDIR}/${ENVDFILE}
	echo "# preserve them for your next emerge of Amanda" >>${MYFILESDIR}/${ENVDFILE}
	cat ${TMPENVFILE} | sed "s,=\$,='',g" >>${MYFILESDIR}/${ENVDFILE}

	into /usr

	# Deprecated, use amtapetype instead
	#einfo "Installing tapetype utility"
	#newsbin tape-src/tapetype tapetype

	# docs
	einfo "Installing documentation"
	dodoc AUTHORS C* INSTALL NEWS README
	# Clean up some bits
	dodoc /usr/share/amanda/*
	rm -rf ${D}/usr/share/amanda
	mkdir -p ${D}/${MYINSTTMPDIR} || die
	cp ${TMPENVFILE} "${D}/${TMPINSTENVFILE}" || die
	# our inetd sample
	einfo "Installing standard inetd sample"
	newdoc ${MYFILESDIR}/amanda-inetd.amanda.sample-2.5.1_p3-r1 amanda-inetd.amanda.sample
	# Stock extra docs
	docinto docs
	dodoc ${S}/docs/*
	# Labels
	einfo "Installing labels"
	docinto labels
	dodoc ${S}/example/3hole.ps
	dodoc ${S}/example/8.5x11.ps
	dodoc ${S}/example/DIN-A4.ps
	dodoc ${S}/example/DLT.ps
	dodoc ${S}/example/EXB-8500.ps
	dodoc ${S}/example/HP-DAT.ps
	# Amanda example configs
	einfo "Installing example configurations"
	docinto example
	dodoc ${S}/example/*
	docinto example1
	newdoc ${FILESDIR}/example_amanda.conf amanda.conf
	newdoc ${FILESDIR}/example_disklist-2.5.1_p3-r1 disklist
	newdoc ${FILESDIR}/example_global.conf global.conf
	docinto example2
	newdoc ${S}/example/amanda.conf amanda.conf
	newdoc ${S}/example/disklist disklist
	# Compress it all
	prepalldocs

	# Just make sure it exists for XFS to work...
	use !sparc && use xfs && keepdir /var/xfsdump/inventory

	insinto /etc/amanda
	einfo "Installing .amandahosts File for ${AMANDA_USER_NAME} user"

	cat ${MYFILESDIR}/amanda-amandahosts-client-2.5.1_p3-r1 \
		>>${D}/etc/amanda/amandahosts
	use minimal \
	|| cat ${MYFILESDIR}/amanda-amandahosts-server-2.5.1_p3-r1 \
		>>${D}/etc/amanda/amandahosts

	dosym /etc/amanda/amandahosts ${AMANDA_USER_HOMEDIR}/.amandahosts
	insinto ${AMANDA_USER_HOMEDIR}
	einfo "Installing .profile for ${AMANDA_USER_NAME} user"
	newins ${MYFILESDIR}/amanda-profile .profile

	einfo "Installing Sample Daily Cron Job for Amanda"
	CRONDIR=/etc/cron.daily/
	exeinto ${CRONDIR}
	newexe ${MYFILESDIR}/amanda-cron amanda
	# Not executable by default
	fperms 644 ${CRONDIR}/amanda

	insinto /etc/amanda/${AMANDA_CONFIG_NAME}
	keepdir /etc/amanda
	keepdir /etc/amanda/${AMANDA_CONFIG_NAME}

	local i
	for i in ${AMANDA_USER_HOMEDIR} ${AMANDA_TAR_LISTDIR} \
		${AMANDA_TMPDIR} ${AMANDA_TMPDIR}/dumps \
		${AMANDA_USER_HOMEDIR}/${AMANDA_CONFIG_NAME} \
		/etc/amanda /etc/amanda/${AMANDA_CONFIG_NAME}; do
		einfo "Securing directory (${i})"
		dodir ${i}
		keepdir ${i}
		fowners ${AMANDA_USER_NAME}:${AMANDA_GROUP_NAME} ${i}
		fperms 700 ${i}
	done

	einfo "Setting setuid permissions"
	amanda_permissions_fix ${D}

	# DevFS
	einfo "Installing DevFS config file"
	insinto /etc/devfs.d
	newins ${MYFILESDIR}/amanda-devfs amanda

	# Env.d
	einfo "Installing environment config file"
	doenvd ${MYFILESDIR}/${ENVDFILE}

	# Installing Amanda Xinetd Services Definition
	einfo "Installing xinetd service file"
	insinto /etc/xinetd.d
	newins ${MYFILESDIR}/amanda-xinetd-2.5.1_p3-r1 amanda

}

pkg_postinst() {
	local aux="${ROOT}/${TMPINSTENVFILE}"
	[ ! -f "${aux}" ] && die "Variable setting file (${aux}) should exist!"
	source "${aux}"
	rm "${aux}"
	rmdir ${ROOT}/${MYINSTTMPDIR} 2>/dev/null # ignore error

	local i
	for i in amandates dumpdates; do
		einfo "Creating inital Amanda file (${i})"
		touch ${ROOT}/etc/${i}
		chown ${AMANDA_USER_NAME}:${AMANDA_GROUP_NAME} ${ROOT}/etc/${i}
		chmod 600 ${ROOT}/etc/${i}
	done

	# If USE=minimal, give out a warning, if AMANDA_SERVER is not set to
	# another host than HOSTNAME.
	if use minimal; then
		if [[ "${AMANDA_SERVER}" = "${HOSTNAME}" ]]; then
			echo
			ewarn "You are installing a client-only version of Amanda."
			ewarn "You should set the variable $AMANDA_SERVER to point at your"
			ewarn "Amanda-tape-server, otherwise you will have to specify its name"
			ewarn "when using amrecover on the client."
			ewarn "For example: Use something like"
			ewarn "AMANDA_SERVER=\"myserver\" emerge amanda"
			echo
		fi
	fi

	einfo "Checking setuid permissions"
	amanda_permissions_fix ${ROOT}

	elog "You should configure Amanda in /etc/amanda now."
	elog
	elog "If you use xinetd, Don't forget to check /etc/xinetd.d/amanda"
	elog "and restart xinetd afterwards!"
	elog
	elog "Otherwise, please look at /usr/share/doc/${P}/inetd.amanda.sample"
	elog "as an example of how to configure your inetd."
	elog
	elog "NOTICE: If you need raw access to partitions you need to add the"
	elog "amanda user to the 'disk' group and uncomment following lines in"
	elog "your /etc/devfs.d/amanda:"
	elog "SCSI:"
	elog "REGISTER   ^scsi/host.*/bus.*/target.*/lun.*/part[0-9]  PERMISSIONS root.disk 660"
	elog "IDE:"
	elog "REGISTER   ^ide/host.*/bus.*/target.*/lun.*/part[0-9]   PERMISSIONS root.disk 660"
	elog
	elog "NOTICE: If you have a tape changer, also uncomment the following"
	elog "REGISTER   ^scsi/host.*/bus.*/target.*/lun.*/generic    PERMISSIONS root.disk 660"
	elog
	elog "If you use localhost in your disklist your restores may break."
	elog "You should replace it with the actual hostname!"
	elog "Please also see the syntax changes to amandahosts."
}

# We have had reports of amanda file permissions getting screwed up.
# Losing setuid, becoming too lax etc.
# ONLY root and users in the amanda group should be able to run these binaries!
amanda_permissions_fix() {
	local root="$1"
	[ -z "${root}" ] && die "Failed to pass root argument to amanda_permissions_fix!"
	for i in /usr/sbin/amcheck /usr/libexec/calcsize /usr/libexec/killpgrp \
		/usr/libexec/rundump /usr/libexec/runtar /usr/libexec/dumper \
		/usr/libexec/planner ; do
		chown root:${AMANDA_GROUP_NAME} ${root}/${i}
		chmod u=srwx,g=rx,o= ${root}/${i}
	done
}
