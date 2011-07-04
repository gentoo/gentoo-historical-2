# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/slurm/slurm-2.2.7.ebuild,v 1.2 2011/07/04 07:51:12 alexxy Exp $

EAPI=4

inherit eutils pam

DESCRIPTION="SLURM: A Highly Scalable Resource Manager"
HOMEPAGE="https://computing.llnl.gov/linux/slurm/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="maui +munge mysql pam postgres ssl static-libs"

DEPEND="
	!sys-cluster/torque
	!net-analyzer/slurm
	mysql? ( dev-db/mysql )
	munge? ( sys-auth/munge )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql-base )
	ssl? ( dev-libs/openssl )
	>=sys-apps/hwloc-1.1.1-r1"
RDEPEND="${DEPEND}
	maui? ( sys-cluster/maui[slurm] )"

pkg_setup() {
	enewgroup slurm
	enewuser slurm -1 -1 /var/spool/slurm slurm
}

src_prepare() {
	# gentoo uses /sys/fs/cgroup instead of /dev/cgroup
	sed -e 's:/dev/cgroup:/sys/fs/cgroup:g' \
		-i "${S}/doc/man/man5/cgroup.conf.5" \
		-i "${S}/etc/cgroup.conf.example" \
		-i "${S}/etc/cgroup.release_agent" \
		-i "${S}/src/plugins/proctrack/cgroup/xcgroup.h" \
		|| die
	# and pids should go to /var/run/slurm
	sed -e 's:/var/run/slurmctld.pid:/var/run/slurm/slurmctld.pid:g' \
		-e 's:/var/run/slurmd.pid:/var/run/slurm/slurmd.pid:g' \
		-i "${S}/etc/slurm.conf.example"
	# also state dirs are in /var/spool/slurm
	sed -e 's:StateSaveLocation=/tmp:StateSaveLocation=/var/spool/slurm:g' \
		-e 's:SlurmdSpoolDir=/tmp/slurmd:SlurmdSpoolDir=/var/spool/slurm/slurmd:g' \
		-i "${S}/etc/slurm.conf.example"
}

src_configure() {
	local myconf=(
			--sysconfdir="${EPREFIX}/etc/${PN}"
			--with-hwloc="${EPREFIX}/usr"
			)
	use pam && myconf+=( --with-pam_dir=$(getpam_mod_dir) )
	use mysql && myconf+=( --with-mysql_config="${EPREFIX}/usr/bin/mysql_config" )
	use postgres && myconf+=( --with-pg_config="${EPREFIX}/usr/bin/pg_config" )
	econf "${myconf[@]}" \
		$(use_enable pam) \
		$(use_with ssl) \
		$(use_with munge) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	use pam && emake -C contribs/pam || die
}

src_install() {
	default
	emake DESTDIR="${D}" -C contribs/torque install || die
	use pam && emake DESTDIR="${D}" -C contribs/pam install || die
	use static-libs || find "${ED}" -name '*.la' -exec rm {} +
	# we dont need it
	rm "${ED}/usr/bin/mpiexec" || die
	# install sample configs
	keepdir /etc/slurm
	keepdir /var/log/slurm
	keepdir /var/spool/slurm
	keepdir /var/run/slurm
	insinto /etc/slurm
	doins etc/cgroup.conf.example
	doins etc/federation.conf.example
	doins etc/slurm.conf.example
	doins etc/slurmdbd.conf.example
	exeinto /etc/slurm
	doexe etc/cgroup.release_agent
	doexe etc/slurm.epilog.clean
	# install init.d files
	newinitd "${FILESDIR}/slurmd.initd" slurmd
	newinitd "${FILESDIR}/slurmctld.initd" slurmctld
	newinitd "${FILESDIR}/slurmdbd.initd" slurmdbd
	# install conf.d files
	newconfd "${FILESDIR}/slurm.confd" slurm
}

pkg_preinst() {
	if use munge; then
		sed -i 's,\(PBS_USE_MUNGE=\).*,\11,' "${D}"etc/conf.d/slurm || die
	fi
}

pkg_postinst() {
	einfo "Fixing permissions in /var/spool/${PN}"
	chown -R ${PN}:${PN} /var/spool/${PN}
	einfo "Fixing permissions in /var/run/${PN}"
	chown -R ${PN}:${PN} /var/run/${PN}
	einfo "Fixing permissions in /var/log/${PN}"
	chown -R ${PN}:${PN} /var/log/${PN}
	echo

	elog "Please visit the file '/usr/share/doc/${P}/html/configurator.html"
	elog "through a (javascript enabled) browser to create a configureation file."
	elog "Copy that file to /etc/slurm.conf on all nodes (including the headnode) of your cluster."
}
