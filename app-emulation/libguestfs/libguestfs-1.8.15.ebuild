# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/libguestfs/libguestfs-1.8.15.ebuild,v 1.1 2011/12/11 19:34:22 maksbotan Exp $

EAPI="3"

WANT_AUTOMAKE="1.11"

JAVA_PKG_OPT_USE="java"
JAVA_PKG_ALLOW_VM_CHANGE="yes"
APLANCE_PV="1.7.18"
PYTHON_DEPEND="python? 2:2.6"
USE_RUBY="ruby18"
RUBY_OPTIONAL="yes"
PHP_EXT_NAME="guestfs_php"
USE_PHP="php5-3"
PHP_EXT_OPTIONAL_USE="php"

inherit autotools bash-completion-r1 confutils versionator java-pkg-opt-2 perl-module python ruby-ng php-ext-source-r2 ghc-package

MY_PV_1="$(get_version_component_range 1-2)"
MY_PV_2="$(get_version_component_range 2)"

[[ $(( $(get_version_component_range 2) % 2 )) -eq 0 ]] && SD="stable" || SD="development"

DESCRIPTION="Library for accessing and modifying virtual machine (VM) disk images"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/${MY_PV_1}-${SD}/${P}.tar.gz
	http://rion-overlay.googlecode.com/files/${PN}-${APLANCE_PV}-x86_64.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# Upstream NOT supported 32-bit version, keyword in own risk
KEYWORDS="~amd64"
IUSE="fuse +ocaml perl python ruby haskell +readline nls php debug doc nls source javadoc"

COMMON_DEPEND="
	virtual/perl-Getopt-Long
	>=dev-perl/Sys-Virt-0.2.4
	>=app-misc/hivex-1.2.1[perl]
	dev-perl/libintl-perl
	dev-perl/String-ShellQuote
	dev-libs/libpcre
	app-arch/cpio
	dev-lang/perl
	app-cdr/cdrkit
	>=app-emulation/qemu-kvm-0.13[qemu_user_targets_x86_64,qemu_softmmu_targets_x86_64]
	sys-apps/fakeroot
	sys-apps/file
	app-emulation/libvirt
	dev-libs/libxml2:2
	=dev-util/febootstrap-3*
	>=sys-apps/fakechroot-2.8
	>=app-admin/augeas-0.7.1
	sys-fs/squashfs-tools
	perl? ( virtual/perl-ExtUtils-MakeMaker )
	fuse? ( sys-fs/fuse )
	readline? ( sys-libs/readline )
	doc? ( dev-libs/libxml2 )
	ocaml? ( dev-lang/ocaml
		dev-ml/findlib
		dev-ml/xml-light )
	ruby? ( dev-lang/ruby
			dev-ruby/rake )
	java? ( virtual/jre )
	haskell? ( dev-lang/ghc )"

DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.6
		source? ( app-arch/zip ) )
	doc? ( app-text/po4a )"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.6 )"

PHP_EXT_S="${S}/php/extension"

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup

	if use python; then
		python_set_active_version 2
		python_pkg_setup
		python_need_rebuild
	fi

	confutils_use_depend_all source java
	confutils_use_depend_all javadoc java

	use ruby && ruby-ng_pkg_setup
	use haskell && ghc-package_pkg_setup
}

src_unpack() {
	unpack ${P}.tar.gz

	cd "${WORKDIR}"
	mkdir image || die
	cd image || die
	unpack libguestfs-${APLANCE_PV}-x86_64.tar.gz
	cp "${WORKDIR}"/image/usr/local/lib/guestfs/* "${S}"/appliance/ || die

	# part of php-ext-source-r2_src_unpack
	# whole version cannot be called here as it will attempt to unpack ${A}
	if use php; then
		local slot orig_s="${PHP_EXT_S}"
		for slot in $(php_get_slots); do
			cp -r "${orig_s}" "${WORKDIR}/${slot}" || die
		done
	fi
}

src_prepare() {
	epatch  "${FILESDIR}/1.8/${PV}"/configure_ac_automagic.patch
	epatch  "${FILESDIR}/1.8/${PV}"/disable_php_in_makefile.patch

	use java && java-pkg-opt-2_src_prepare
	eautoreconf

	if use php; then
		php-ext-source-r2_src_prepare
	fi
}

src_configure() {

	# Disable feature test for kvm for more reason
	# i.e: not loaded module in __build__ time,
	# build server not supported kvm, etc. ...
	#
	# In fact, this feature is virtio support and requires 
	# configured kernel.
	export vmchannel_test=no

	econf  \
		--with-repo=fedora-12 \
		--disable-appliance \
		--disable-daemon \
		--with-drive-if=virtio \
		--with-net-if=virtio-net-pci \
		--disable-rpath \
		$(use_enable java) \
		$(use_enable nls) \
		$(use_with readline) \
		$(use_enable ocaml ocaml-viewer) \
		$(use_enable perl) \
		$(use_enable fuse) \
		$(use_enable ocaml) \
		$(use_enable python) \
		$(use_enable ruby) \
		$(use_enable haskell) \
		$(use_with doc po4a)

	    if use php; then
			php-ext-source-r2_src_configure
	    fi
}

src_compile() {
	emake  || die

	if use php; then
		php-ext-source-r2_src_compile
	fi
}

src_test() {
	emake -j1 check || die
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die

	dodoc BUGS HACKING README RELEASE-NOTES TODO

	dobashcomp "${D}/etc"/bash_completion.d/guestfish-bash-completion.sh

	rm -fr "${D}/etc"/bash* || die

	insinto /usr/$(get_libdir)/guestfs/
	doins "${WORKDIR}/image/usr/local/lib/"guestfs/*

	find "${D}" -name '*.la' -exec rm -f '{}' +
	if use java; then
		java-pkg_newjar  java/${P}.jar ${PN},jar
		rm  -fr  "${D}/usr"/share/java
		rm  -fr  "${D}/usr"/share/javadoc
		if use source;then
			java-pkg_dosrc java/com/redhat/et/libguestfs/*
		fi
		if use javadoc;then
			java-pkg_dojavadoc java/api
		fi
	fi

	use perl && fixlocalpod
	python_clean_installation_image -q

	if use php; then
		php-ext-source-r2_src_install
	fi
}

pkg_preinst() {
	use java && java-pkg-opt-2_pkg_preinst
}

pkg_postinst() {
	use haskell && ghc-package_pkg_postinst
}

pkg_prerm() {
	use haskell && ghc-package_pkg_prerm
}
