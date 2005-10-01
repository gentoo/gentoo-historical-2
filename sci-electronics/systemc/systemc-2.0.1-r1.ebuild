# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/systemc/systemc-2.0.1-r1.ebuild,v 1.1 2005/10/01 14:54:29 ribosome Exp $

inherit portability

DESCRIPTION="A C++ based modeling platform for VLSI and system-level co-design"
LICENSE="SOPLA-2.4"
HOMEPAGE="http://www.systemc.org/"
SRC_URI="${P}.tgz"

SLOT="0"
IUSE=""
KEYWORDS="~x86"

RESTRICT="fetch"

DEPEND="virtual/libc"

pkg_nofetch() {
	einfo "${PN} developers require end-users to accept their license agreement"
	einfo "by registering on their Web site (${HOMEPAGE})."
	einfo "Please download ${A} manually and place it in ${DISTDIR}."
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "s:OPT_CXXFLAGS=\"-O3\":OPT_CXXFLAGS=\"${CXXFLAGS}\":g" \
		-i configure || die "sedding configure script failed"
	chmod +x configure
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
	cd "${S}"/src/systemc/kernel
	ar cru ../../../src/libsystemc.a sc_attribute.o sc_cor_fiber.o \
		sc_cor_qt.o sc_event.o sc_kernel_ids.o sc_lambda.o sc_main.o \
		sc_module.o sc_module_name.o sc_module_registry.o sc_name_gen.o \
		sc_object.o sc_object_manager.o sc_process_int.o sc_runnable.o \
		sc_sensitive.o sc_simcontext.o sc_time.o sc_ver.o sc_wait.o \
		sc_wait_cthread.o || die "archiving kernel failed"
	cd "${S}"/src/systemc/qt
	ar cru ../../../src/libsystemc.a qt.o qtmdc.o qtmds.o \
		|| die "archiving qt failed"
	cd "${S}"/src/systemc/communication
	ar cru ../../../src/libsystemc.a sc_clock.o sc_communication_ids.o \
		sc_event_finder.o sc_interface.o sc_mutex.o sc_port.o \
		sc_prim_channel.o sc_semaphore.o sc_signal.o sc_signal_ports.o \
		sc_signal_resolved.o sc_signal_resolved_ports.o \
		|| die "archiving commmunication failed)"
	cd "${S}"/src/systemc/datatypes/bit
	ar cru ../../../../src/libsystemc.a sc_bit.o sc_bit_ids.o sc_bv_base.o \
		sc_logic.o sc_lv_base.o || die "archiving bit failed"
	cd "${S}"/src/systemc/datatypes/fx
	ar cru ../../../../src/libsystemc.a sc_fx_ids.o sc_fxcast_switch.o \
		sc_fxdefs.o sc_fxnum.o sc_fxnum_observer.o sc_fxtype_params.o \
		sc_fxval.o sc_fxval_observer.o scfx_mant.o scfx_pow10.o scfx_rep.o \
		scfx_utils.o || die "archiving fx failed"
	cd "${S}"/src/systemc/datatypes/int
	ar cru ../../../../src/libsystemc.a sc_int_base.o sc_int32_mask.o \
		sc_int64_io.o sc_int64_mask.o sc_int_ids.o sc_length_param.o \
		sc_nbdefs.o sc_nbexterns.o sc_nbutils.o sc_signed.o sc_uint_base.o \
		sc_unsigned.o || die "archiving int failed"
	cd "${S}"/src/systemc/tracing
	ar cru ../../../src/libsystemc.a sc_isdb_trace.o sc_trace.o \
		sc_vcd_trace.o sc_wif_trace.o || die "archiving tracing failed"
	cd "${S}"/src/systemc/utils
	ar cru ../../../src/libsystemc.a sc_exception.o sc_hash.o sc_list.o \
		sc_mempool.o sc_pq.o sc_report.o sc_report_handler.o sc_stop_here.o \
		sc_string.o sc_utils_ids.o sc_vector.o || die "archiving utils failed"
}

src_install() {
	cd "${S}"/src
	dolib.a libsystemc.a
	dodir /usr/include/systemc
	find . -name "*.h" -exec treecopy {} "${D}"/usr/include/ \;
	cd "${S}"
	dodoc AUTHORS NEWS README RELEASENOTES
	dodir /usr/share/doc/${PF}/examples
	cp docs/*.pdf "${D}"/usr/share/doc/${PF}
	cp -r examples/systemc/* "${D}"/usr/share/doc/${PF}/examples
	cd "${D}"/usr/share/doc/${PF}/examples
	rm Makefile Makefile.am Makefile.in
	sed -e "s:LIBDIR =:#LIBDIR =:g" -e "s:\$(EXE).*:\$(EXE)\: \$(OBJS):g" \
		-i Makefile.defs
}
