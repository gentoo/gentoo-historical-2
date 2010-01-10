# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/torque/torque-2.3.7.ebuild,v 1.4 2010/01/10 01:22:39 robbat2 Exp $

EAPI=2
inherit flag-o-matic eutils linux-info

DESCRIPTION="Resource manager and queuing system based on OpenPBS"
HOMEPAGE="http://www.clusterresources.com/products/torque/"
SRC_URI="http://www.clusterresources.com/downloads/${PN}/${P}.tar.gz"

LICENSE="openpbs"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="tk +crypt drmaa server +syslog doc cpusets kernel_linux"
PROVIDE="virtual/pbs"

# ed is used by makedepend-sh
DEPEND_COMMON="sys-libs/ncurses
	sys-libs/readline
	tk? ( dev-lang/tk )
	syslog? ( virtual/logger )
	!games-util/qstat"

DEPEND="${DEPEND_COMMON}
	sys-apps/ed"

RDEPEND="${DEPEND_COMMON}
	crypt? ( net-misc/openssh )
	!crypt? ( net-misc/netkit-rsh )"

pkg_setup() {
	PBS_SERVER_HOME="${PBS_SERVER_HOME:-/var/spool/torque}"

	USE_CPUSETS="--disable-cpusets"
	if use cpusets; then
		if ! use kernel_linux; then
			einfo
			elog "    Torque currently only has support for cpusets in linux."
			elog "Assuming you didn't really want this USE flag."
			einfo
		else
			linux-info_pkg_setup
			einfo
			elog "    Torque support for cpusets is still in development, you may"
			elog "wish to disable it for production use."
			einfo
			if ! linux_config_exists || ! linux_chkconfig_present CPUSETS; then
				einfo
				elog "    Torque support for cpusets will require that you recompile"
				elog "your kernel with CONFIG_CPUSETS enabled."
				einfo
			fi
			USE_CPUSETS="--enable-cpusets"
		fi
	fi
}

src_configure() {
	local myconf="--with-rcp=mom_rcp"

	use crypt && myconf="--with-rcp=scp"

	[ -n "${PBS_SERVER_NAME}" ] || PBS_SERVER_NAME=$(hostname -f)

	econf \
		$(use_enable tk gui) \
		$(use_enable syslog) \
		$(use_enable server) \
		$(use_enable drmaa) \
		--with-server-home=${PBS_SERVER_HOME} \
		--with-environ=/etc/pbs_environment \
		--with-default-server=${PBS_SERVER_NAME} \
		--disable-gcc-warnings \
		${USE_CPUSETS} \
		${myconf} \
		|| die "econf failed"
}

# WARNING
# OpenPBS is extremely stubborn about directory permissions. Sometimes it will
# just fall over with the error message, but in some spots it will just ignore
# you and fail strangely. Likewise it also barfs on our .keep files!
pbs_createspool() {
	local root="$1"
	local s="$(dirname "${PBS_SERVER_HOME}")"
	local h="${PBS_SERVER_HOME}"
	local sp="${h}/server_priv"
	einfo "Building spool directory under ${D}${h}"
	local a d m
	local dir_spec="
			0755:${h}/aux 0700:${h}/checkpoint
			0755:${h}/mom_logs 0751:${h}/mom_priv 0751:${h}/mom_priv/jobs
			1777:${h}/spool 1777:${h}/undelivered"

	if use server; then
		dir_spec="${dir_spec} 0755:${h}/sched_logs
			0755:${h}/sched_priv/accounting 0755:${h}/server_logs
			0750:${h}/server_priv 0755:${h}/server_priv/accounting
			0750:${h}/server_priv/acl_groups 0750:${h}/server_priv/acl_hosts
			0750:${h}/server_priv/acl_svr 0750:${h}/server_priv/acl_users
			0750:${h}/server_priv/jobs 0750:${h}/server_priv/queues"
	fi

	for a in ${dir_spec}; do
		d="${a/*:}"
		m="${a/:*}"
		if [[ ! -d "${root}${d}" ]]; then
			install -d -m${m} "${root}${d}"
		else
			chmod ${m} "${root}${d}"
		fi
		# (#149226) If we're running in src_*, then keepdir
		if [[ "${root}" = "${D}" ]]; then
			keepdir ${d}
		fi
	done
}

src_install() {
	# Make directories first
	pbs_createspool "${D}"

	make DESTDIR="${D}" install || die "make install failed"

	dodoc CHANGELOG DEVELOPMENT README.* Release_Notes || die "dodoc failed"
	if use doc; then
		dodoc doc/admin_guide.ps doc/*.pdf || die "dodoc failed"
	fi

	# The build script isn't alternative install location friendly,
	# So we have to fix some hard-coded paths in tclIndex for xpbs* to work
	for file in `find "${D}" -iname tclIndex`; do
		sed -e "s/${D//\// }/ /" "${file}" > "${file}.new"
		mv "${file}.new" "${file}"
	done

	if use server; then
		newinitd "${FILESDIR}"/pbs_server-init.d-2.2.1-r1 pbs_server
		newinitd "${FILESDIR}"/pbs_sched-init.d-2.2.1-r1 pbs_sched
	fi
	newinitd "${FILESDIR}"/pbs_mom-init.d-2.2.1-r1 pbs_mom
	newconfd "${FILESDIR}"/torque-conf.d-2.2.1-r1 torque
	newenvd "${FILESDIR}"/torque-env.d-2.2.1-r1 25torque
}

pkg_preinst() {
	if [[ -f "${ROOT}etc/pbs_environment" ]]; then
		cp "${ROOT}etc/pbs_environment" "${D}"/etc/pbs_environment
	fi

	if [ -n "${PBS_SERVER_NAME}" ]; then
		echo "${PBS_SERVER_NAME}" > "${D}${PBS_SERVER_HOME}/server_name"
	elif [[ -f "${ROOT}${PBS_SERVER_HOME}/server_name" ]]; then
		cp "${ROOT}${PBS_SERVER_HOME}/server_name" "${D}${PBS_SERVER_HOME}/server_name"
	fi

	# Fix up the env.d file to use our set server home.
	sed -i "s:/var/spool/torque:${PBS_SERVER_HOME}:g" "${D}"/etc/env.d/25torque
}

pkg_postinst() {
	pbs_createspool "${ROOT}"
	elog "    If this is the first time torque has been installed, then you are not"
	elog "ready to start the server.  Please refer to the documentation located at:"
	elog "http://www.clusterresources.com/wiki/doku.php?id=torque:torque_wiki"

	elog "    For a basic setup, you may use emerge --config ${PN}"
}

# Either the correct PBS_SERVER_HOME and PBS_SERVER_NAME are set
# or we use the default HOME and the localhost as the server.
# root will be setup as the primary operator/manager, the local machine
# will be added as a node and we'll create a simple queue, batch.
pkg_config() {
	local h="$(echo "${ROOT}/${PBS_SERVER_HOME}" | sed 's:///*:/:g')"
	local rc=0

	ebegin "Configuring Torque"
	[ -n "${PBS_SERVER_NAME}" ] || PBS_SERVER_NAME=$(hostname -f)
	einfo "Using ${h} as the pbs homedir"
	einfo "Using ${PBS_SERVER_NAME} as the pbs_server"

	# Check for previous configuration and bail if found.
	if [ -e "${h}/server_priv/acl_svr/operators" ] \
		|| [ -e "${h}/server_priv/nodes" ] \
		|| [ -e "${h}/mom_priv/config" ]; then
		ewarn "Previous Torque configuration detected.  Press any key to"
		ewarn "continue or press Control-C to abort now"
		read
	fi

	# pbs_mom configuration.
	echo "\$pbsserver ${PBS_SERVER_NAME}" > "${h}/mom_priv/config"
	echo "\$logevent 255" >> "${h}/mom_priv/config"

	if use server; then
		local qmgr="${ROOT}/usr/bin/qmgr -c"
		# pbs_server bails on repeated backslashes.
		if ! echo "y" | "${ROOT}"/usr/sbin/pbs_server -d "${h}" -t create; then
			eerror "Failed to start pbs_server"
			rc=1
		else
			${qmgr} "set server operators = root@$(hostname -f)" ${PBS_SERVER_NAME}
			${qmgr} "create queue batch" ${PBS_SERVER_NAME}
			${qmgr} "set queue batch queue_type = Execution" ${PBS_SERVER_NAME}
			${qmgr} "set queue batch started = True" ${PBS_SERVER_NAME}
			${qmgr} "set queue batch enabled = True" ${PBS_SERVER_NAME}
			${qmgr} "set server default_queue = batch" ${PBS_SERVER_NAME}
			${qmgr} "set server resources_default.nodes = 1" ${PBS_SERVER_NAME}
			${qmgr} "set server scheduling = True" ${PBS_SERVER_NAME}

			"${ROOT}"/usr/bin/qterm -t quick ${PBS_SERVER_NAME} || rc=1

			# Add the local machine as a node.
			echo "$(hostname -f) np=1" > "${h}/server_priv/nodes"
		fi
	fi
	eend ${rc}
}
